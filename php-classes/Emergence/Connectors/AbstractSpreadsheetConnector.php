<?php

namespace Emergence\Connectors;

use ActiveRecord;
use SpreadsheetReader;
use Psr\Log\LogLevel;

class AbstractSpreadsheetConnector extends \Emergence\Connectors\AbstractConnector
{
    use \Emergence\Classes\StackedConfigTrait;

    public static $logRowColumnCount = 3;

    public static $onBeforeValidateRecord;
    public static $onValidateRecord;
    public static $onBeforeSaveRecord;
    public static $onSaveRecord;

    // protected methods
    protected static function initRequiredColumns(array $config)
    {
        $requiredColumns = [];

        foreach ($config AS $key => $value) {
            if (!$value) {
                if (is_string($key) && array_key_exists($key, $requiredColumns)) {
                    unset($requiredColumns[$key]);
                }
                continue;
            }

            if (!is_string($key)) {
                $key = $value;
                $value = true;
            }

            $requiredColumns[$key] = $value;
        }

        return $requiredColumns;
    }

    protected static function _requireColumns($noun, SpreadsheetReader $spreadsheet, array $requiredColumns, array $columnsMap = null)
    {
        $columns = $spreadsheet->getColumnNames();
        $requiredColumns = array_keys(array_filter($requiredColumns));

        if ($columnsMap) {
            $mappedColumns = array();
            foreach ($columns AS $columnName) {
                $mappedColumns[] = array_key_exists($columnName, $columnsMap) ? $columnsMap[$columnName] : $columnName;
            }
            $columns = $mappedColumns;
        }

        $missingColumns = array_diff($requiredColumns, $columns);

        if (count($missingColumns)) {
            throw new \Exception(
                $noun.' spreadsheet is missing required column'.(count($missingColumns) != 1 ? 's' : '').': '
                .join(',', $missingColumns)
                .'. Found columns: '
                .join(', ', $columns)
            );
        }
    }

    protected static function _readRow(array $row, array $columnsMap)
    {
        $output = array();

        foreach ($columnsMap as $externalKey => $internalKey) {
            if (array_key_exists($externalKey, $row)) {
                if ($internalKey) {
                    if (substr($internalKey, -2) == '[]') {
                        $internalKey = substr($internalKey, 0, -2);

                        if (!array_key_exists($internalKey, $output)) {
                            $output[$internalKey] = [$row[$externalKey]];
                        } elseif (is_array($output[$internalKey])) {
                            $output[$internalKey][] = $row[$externalKey];
                        } else {
                            $output[$internalKey] = [$output[$internalKey], $row[$externalKey]];
                        }
                    } else {
                        $output[$internalKey] = $row[$externalKey];
                    }
                }

                unset($row[$externalKey]);
            }
        }

        foreach ($output as $key => &$value) {
            if (is_array($value)) {
                $value = array_filter($value);
            }
        }

        $output['_rest'] = $row;

        return $output;
    }

    protected static function _logRow(Job $Job, $noun, $rowNumber, array $row)
    {
        $nonEmptyColumns = array_filter($row);
        unset($nonEmptyColumns['_rest']);

        $summaryColumns = array_slice($nonEmptyColumns, 0, static::$logRowColumnCount, true);

        $Job->log(
            LogLevel::DEBUG,
            'Analyzing {noun} row #{rowNumber}: {rowSummary}',
            [
                'noun' => $noun,
                'rowNumber' => $rowNumber,
                'rowSummary' => http_build_query($summaryColumns).(count($nonEmptyColumns) > count($summaryColumns) ? '&...' : '')
            ]
        );
    }

    protected static function _validateRecord(Job $Job, ActiveRecord $Record, array &$results)
    {
        // call configurable hook
        if (is_callable(static::$onBeforeValidateRecord)) {
            call_user_func(static::$onBeforeValidateRecord, $Job, $Record, $results);
        }


        // validate and store result
        $isValid = $Record->validate();


        // trace any failed validation in the log and in the results
        if (!$isValid) {
            $firstErrorField = key($Record->validationErrors);
            $error = $Record->validationErrors[$firstErrorField];
            $results['failed']['invalid'][$firstErrorField][is_array($error) ? http_build_query($error) : $error]++;
            $Job->logInvalidRecord($Record);
        }


        // call configurable hook
        if (is_callable(static::$onValidateRecord)) {
            call_user_func(static::$onValidateRecord, $Job, $Record, $results, $isValid);
        }


        return $isValid;
    }

    protected static function _saveRecord(Job $Job, ActiveRecord $Record, $pretend, array &$results, $logOptions = array())
    {
        // call configurable hook
        if (is_callable(static::$onBeforeSaveRecord)) {
            call_user_func(static::$onBeforeSaveRecord, $Job, $Record, $results, $pretend, $logOptions);
        }


        // generate log entry
        $logEntry = $Job->logRecordDelta($Record, $logOptions);

        if ($logEntry['action'] == 'create') {
            $results['created']++;
        } elseif ($logEntry['action'] == 'update') {
            $results['updated']++;

            foreach (array_keys($logEntry['changes']) AS $changedField) {
                $results['updated-fields'][$changedField]++;
            }
        }


        // save changes
        if (!$pretend) {
            $Record->save();
        }


        // call configurable hook
        if (is_callable(static::$onSaveRecord)) {
            call_user_func(static::$onSaveRecord, $Job, $Record, $results, $pretend, $logOptions);
        }
    }
}