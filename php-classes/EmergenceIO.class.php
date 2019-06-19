<?php

class EmergenceIO
{
    /*  function export
     *
     *  @params string  $path   Emergence Virtual Directory to Export, If empty will export entire site.
     *  @params string  $destination    Optionally lets you set where to save the output locally on the server.
     *
     *  @returns string     Server path to file
     */
    public static function export($path=null,$destination=null)
    {
        set_time_limit(0);

        if (!is_array($path) && !empty($path)) {
            $path = Site::splitPath($path);
        }

        if (empty($path)) {
            $files = DB::allRecords(
                'SELECT MAX(`ID`) as `RID`'
                .' FROM `_e_files`'
                //." WHERE `Status` = 'Normal'"
.' GROUP BY  `Handle`,`CollectionID`'
            );

            foreach ($files as $file) {
                $SiteFile = SiteFile::getByID($file['RID'])->getData();
                if (strpos($SiteFile['FullPath'],'_parent') !== 0 && $SiteFile['Status'] != 'Deleted') {
                    $SiteFiles[$SiteFile['FullPath']] = Site::$rootPath.'/data/'.$SiteFile['ID'];
                }
            }
        } else {
            throw new Exception('Sub directories not yet supported.');
        }

        if (count($SiteFiles)) {
            $zip = new ZipArchive;

            $tmp = $destination?$destination:tempnam("/tmp", "emr");

            if ($zip->open($tmp) === TRUE) {
                foreach ($SiteFiles as $virtualPath => $realPath) {
                    $zip->addFromString($virtualPath,file_get_contents($realPath));
                }
            }
            $zip->close();

            return $tmp;
        } else {
            throw new Exception('Nothing to compress found.');
        }
    }

    /*  function import
     *
     *  @params string  $inputFile          The real location of the file to import on the server.
     *  @params string  $targetDirectory    Optionally provide the Emergence virtual directory to extract to.
     */
    public static function import($inputFile,$targetDirectory=null)
    {
        if (!$targetDirectory) {
            $targetDirectory = '';
        }

        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $type = finfo_file($finfo, $inputFile);
        finfo_close($finfo);

        switch ($type) {
            case 'application/zip':
                $zip = new ZipArchive();
                $zip->open($inputFile);

                $i = 0;
                while ($i < $zip->numFiles) {
                    $file = $zip->statIndex($i);
                    $contents = '';
                    $fp = $zip->getStream($file['name']);
                    while (!feof($fp)) {
                        $contents .= fread($fp, 2);
                    }
                    SiteCollection::createFile($targetDirectory.$file['name'],$contents);
                    fclose($fp);
                    $i++;
                }
            break;
            default:
                throw new Exception('MIME type '.$type.' unsupported.');
        }
    }
}