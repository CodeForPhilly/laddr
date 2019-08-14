<?php

namespace Emergence\Redirects;

use DB;
use Site;
use Cache;
use TableNotFoundException;

class Redirect extends \ActiveRecord
{
    public static $tableName = 'redirects';
    public static $collectionRoute = '/redirects';
    public static $singularNoun = 'redirect';
    public static $pluralNoun = 'redirects';

    public static $fields = [
        'From' => [
            'unique' => true
        ],
        'To'
    ];

    public static $validators = [
        'From',
        'To'
    ];

    public function validate($deep = true)
    {
        // ensure To and From are free from trailing/leading slashes
        if ($this->isFieldDirty('From')) {
            $this->From = trim($this->From, '/');
        }

        if ($this->isFieldDirty('To')) {
            $this->To = trim($this->To, '/');
        }

        // continue validation
        parent::validate($deep);

        // check if From is already mapped
        if (
            $this->isFieldDirty('From') &&
            ($Existing = static::getByField('From', $this->From)) &&
            $Existing->ID != $this->ID
        ) {
            $this->_validator->addError('From', _('A redirect exists already with the same From'));
        } elseif ($this->From == $this->To) {
            $this->_validator->addError('To', _('From and To match, this would create an infinite redirect'));
        }

        return $this->finishValidation();
    }

    public function save($deep = true)
    {
        // continue save
        parent::save($deep);

        // update cache
        if (($this->isUpdated || $this->isNew) && null !== ($redirects = static::getRedirectsTable(true))) {
            if ($oldFrom = $this->getOriginalValue('From')) {
                unset($redirects[$oldFrom]);
            }

            $redirects[$this->From] = $this->To;
            Cache::store('redirects', $redirects);
        }
    }

    public function destroy()
    {
        // continue destroy
        $result = parent::destroy();

        // update cache
        if (null !== ($redirects = static::getRedirectsTable(true))) {
            unset($redirects[$this->From]);
            Cache::store('redirects', $redirects);
        }

        // pass on result
        return $result;
    }

    public static function getRedirectsTable($cacheOnly = false)
    {
        if (false === ($redirects = Cache::fetch('redirects'))) {
            if ($cacheOnly) {
                return null;
            }

            try {
                $redirects = DB::valuesTable('From', 'To', 'SELECT * FROM `%s`', static::$tableName);
            } catch (TableNotFoundException $e) {
                $redirects = [];
            }

            Cache::store('redirects', $redirects);
        }

        return $redirects;
    }

    public static function getRedirectForPath($path)
    {
        if (!is_array($path)) {
            $path = Site::splitPath($path);
        }

        $redirects = static::getRedirectsTable();

        for ($pathLength = count($path); $pathLength > 0; $pathLength--) {
            $pathSegment = implode('/', array_slice($path, 0, $pathLength));

            if ($redirects[$pathSegment]) {
                $carriedSuffix = implode('/', array_slice($path, $pathLength));

                return $redirects[$pathSegment] . ($carriedSuffix ? '/' . $carriedSuffix : '');
            }
        }

        return null;
    }
}