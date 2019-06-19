<?php



 class ExtJS
 {
     public static function getRecordMetadata($recordClass)
     {
         $metadata = array(
            'root' => 'data'
            ,'successProperty' => 'success'
            ,'totalProperty' => 'total'
            ,'fields' => array()
        );

         foreach ($recordClass::getClassFields() AS $field) {
             if (!$fieldConfig = static::getFieldTypeConfig($field)) {
                 continue;
             }

             $fieldConfig = array_merge(array(
                'name' => $field['columnName']
            ), $fieldConfig);

             if ($field['notnull']) {
                 $fieldConfig['allowBlank'] = false;
             }

             if ($field['autoincrement']) {
                 $metadata['idProperty'] = $field['columnName'];
             }

             $metadata['fields'][] = $fieldConfig;
         }

         return $metadata;
     }

     public static function getFieldTypeConfig($field)
     {
         switch ($field['type']) {
            case 'integer':
                return array('type' => 'int');
            case 'decimal':
                return array('type' => 'float');

            case 'enum':
            case 'set':
            case 'string':
            case 'clob':
            case 'blob':
                return array('type' => 'string');

            case 'timestamp':
                return array('type' => 'date', 'dateFormat' => 'timestamp');
            case 'date':
                return array('type' => 'date', 'dateFormat' => 'Y-m-d');
            case 'year':
                return array('type' => 'date', 'dateFormat' => 'Y');

            case 'serialized':
                return array('type' => 'auto');

            case 'password':
                return false;

            default:
                die("getExtTypeConfig: unhandled type $field[type]");
        }
     }

     public static function getColumnModelConfig($recordClass)
     {
         $columns = array();

         foreach ($recordClass::getClassFields() AS $field) {
             $column = array(
                'id' => $field['columnName']
                ,'dataIndex' => $field['columnName']
                ,'header' => static::getColumnHeader($field)
                ,'sortable' => true
            );

             switch ($field['type']) {
                case 'date':
                    $column['xtype'] = 'datecolumn';
                    $column['format'] = 'M d, Y';
                    $column['width'] = 80;
                    break;

                case 'timestamp':
                    $column['xtype'] = 'datecolumn';
                    $column['format'] = 'M d, Y h:ia';
                    $column['width'] = 130;
                    break;
            }

             $columns[] = $column;
         }

         return $columns;
     }

     public static function getColumnHeader($field)
     {
         return !empty($field['label']) ? $field['label'] : Inflector::spacifyCaps($field['columnName']);
     }


     public static function getJson($value, $indent = 0)
     {
         if (is_string($value)) {
             return "'".str_replace("'","\\'",$value)."'";
         } elseif (is_array($value)) {
             if (static::isAssoc($value)) {
                 $r = '{';

                 $indent++;

                 $first = true;
                 foreach ($value AS $key => $subValue) {
                     $r .= PHP_EOL.str_repeat("\t", $indent);
                     if (!$first) {
                         $r .= ',';
                     }
                     $r .= $key.': '.static::getJson($subValue, $indent);
                     $first = false;
                 }

                 $indent--;

                 $r .= PHP_EOL.str_repeat("\t", $indent);
                 return $r.'}';
             } else {
                 $r = '[';
                 foreach ($value AS $subValue) {
                     if ($r != '[') {
                         $r .= ',';
                     }
                     $r .= static::getJson($subValue, $indent);
                 }
                 return $r.']';
             }
         } else {
             return json_encode($value);
         }
     }

     public static function isAssoc($arr)
     {
         return array_keys($arr) !== range(0, count($arr) - 1);
     }
 }