<?php

namespace Emergence\Site;


class Response implements IResponse
{
    protected $id;
    protected $payload;
    protected $mode;


    public function __construct($id, array $payload = [], $mode = 'html')
    {
        $this->id = $id;
        $this->payload = $payload;
        $this->mode = $mode;
    }


    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;
    }

    public function getPayload()
    {
        return $this->payload;
    }

    public function setPayload(array $payload)
    {
        $this->payload = $payload;
    }

    public function setPayloadKey($key, $value)
    {
        $this->payload[$key] = $value;
    }

    public function getMode()
    {
        return $this->mode;
    }

    public function setMode($mode)
    {
        $this->mode = $mode;
    }
}