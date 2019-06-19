<?php

class EmergenceSyncer
{
    protected $_putCurl;
    protected $_deleteCurl;
    protected $_options;

    public function __construct($options)
    {
        $this->_options = array_merge(array(
            'authUsername' => ''
            ,'authPassword' => ''
            ,'host' => false
        ), $options);

        if (!$this->_options['host']) {
            throw new Exception('host required');
        }

        // create curl instances
        $this->_getCurl = curl_init();
        curl_setopt($this->_getCurl, CURLOPT_USERPWD, $this->_options['authUsername'].':'.$this->_options['authPassword']);
        curl_setopt($this->_getCurl, CURLOPT_RETURNTRANSFER, true);

        $this->_putCurl = curl_init();
        curl_setopt($this->_putCurl, CURLOPT_USERPWD, $this->_options['authUsername'].':'.$this->_options['authPassword']);
        curl_setopt($this->_putCurl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($this->_putCurl, CURLOPT_PUT, true);

        $this->_deleteCurl = curl_init();
        curl_setopt($this->_deleteCurl, CURLOPT_USERPWD, $this->_options['authUsername'].':'.$this->_options['authPassword']);
        curl_setopt($this->_deleteCurl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($this->_deleteCurl, CURLOPT_CUSTOMREQUEST, 'DELETE');
    }

    public function get($url)
    {
        curl_setopt($this->_getCurl, CURLOPT_URL, $url);

        $result = curl_exec($this->_getCurl);
        $httpStatus = curl_getinfo($this->_getCurl, CURLINFO_HTTP_CODE);

        return array(
            'status' => $httpStatus
            ,'body' => $result
        );
    }

    public function put($url, SiteFile $node)
    {
        curl_setopt($this->_putCurl, CURLOPT_URL, $url);
        curl_setopt($this->_putCurl, CURLOPT_INFILESIZE, $node->Size);
        curl_setopt($this->_putCurl, CURLOPT_INFILE, $node->get());

        $result = curl_exec($this->_putCurl);
        $httpStatus = curl_getinfo($this->_putCurl, CURLINFO_HTTP_CODE);

        if ($httpStatus < 200 || $httpStatus >= 300) {
            throw new Exception('PUT failed with status '.$httpStatus);
        }

        return array(
            'status' => $httpStatus
            ,'body' => $result
        );
    }

    public function delete($url)
    {
        curl_setopt($this->_deleteCurl, CURLOPT_URL, $url);

        $result = curl_exec($this->_deleteCurl);
        $httpStatus = curl_getinfo($this->_deleteCurl, CURLINFO_HTTP_CODE);

        if ($httpStatus < 200 || $httpStatus >= 300) {
            throw new Exception('DELETE failed with status '.$httpStatus);
        }

        return array(
            'status' => $httpStatus
            ,'body' => $result
        );
    }

    public function pushDiff($diff)
    {
        $results = array();
        foreach ($diff AS $d) {
            if (!$d['operation']) {
                $results[] = array(
                    'path' => $d['local']->FullPath
                    ,'status' => 'skipped'
                );
            } elseif ($d['operation'] == 'create' || $d['operation'] == 'update') {
                //$this->put();
                if (is_array($d['local'])) {
                    $d['local'] = SiteFile::getByID($d['local']['ID']);
                }

                // PUT file
                $url = 'http://'.$this->_options['host'].'/develop/'.$d['local']->FullPath;

                $results[] = array(
                    'path' => $d['local']->FullPath
                    ,'status' => $d['operation'].'d'
                    ,'response' => $this->put($url, $d['local'])
                );
            } elseif ($d['operation'] == 'delete') {
                // DELETE file
                $url = 'http://'.$this->_options['host'].'/develop/'.$d['remote']['FullPath'];

                $results[] = array(
                    'path' => $d['remote']['FullPath']
                    ,'status' => 'deleted'
                    ,'response' => $this->delete($url)
                );
            }
        }

        return $results;
    }

    public function diffCollection($collection, $deep = false)
    {
        $remote = $this->getRemoteCollection('http://'.$this->_options['host'].'/develop/json/'.$collection->FullPath);

        $diff = array();
        foreach ($collection->getChildren() AS $localNode) {
            if ($localNode->Class == 'SiteCollection') {
                if ($localNode->SiteID != 1) {
                    continue;
                }

                if ($deep) {
                    $diff = array_merge($diff, $this->diffCollection($localNode, true));
                }

                unset($remote[$localNode->Handle]);
                continue;
            }

            if (!array_key_exists($localNode->Handle, $remote)) {
                $diff[] = array(
                    'operation' => 'create'
                    ,'local' => $localNode
                );
                continue;
            }

            if ($localNode->SHA1 == $remote[$localNode->Handle]['SHA1']) {
                $diff[] = array(
                    'operation' => null
                    ,'local' => $localNode
                    ,'remote' => $remote[$localNode->Handle]
                );
            } else {
                $diff[] = array(
                    'operation' => 'update'
                    ,'local' => $localNode
                    ,'remote' => $remote[$localNode->Handle]
                );
            }

            unset($remote[$localNode->Handle]);
        }

        foreach ($remote AS $r) {
            if ($r['Class'] == 'SiteCollection' && $r['Site'] != "Local") {
                continue;
            }

            $diff[] = array(
                'operation' => 'delete'
                ,'remote' => $r
            );
        }

        return $diff;
    }

    public function getRemoteCollection($path)
    {
        $response = $this->get($path);

        if ($response['status'] == 404) {
            return array();
        }

        $responseData = json_decode($response['body'], true);

        if (empty($responseData['children'])) {
            return array();
        }

        $collection = array();
        foreach ($responseData['children'] AS $node) {
            $collection[$node['Handle']] = $node;
        }

        return $collection;
    }
}