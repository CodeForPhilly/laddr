<?php
namespace Captcha;

/**
 * Copyright (c) 2015, Aleksey Korzun <aleksey@webfoundation.net>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are those
 * of the authors and should not be interpreted as representing official policies,
 * either expressed or implied, of the FreeBSD Project.
 *
 * reCaptcha response object
 *
 * @author Aleksey Korzun <aleksey@webfoundation.net>
 * @package library
 * @subpackage reCaptcha
 */
class Response
{
    /**
     * Is response valid
     *
     * @var bool
     */
    protected $isValid;

    /**
     * Currently set error message
     *
     * @var string
     */
    protected $error;

    /**
     * Set flag for a valid response indicator
     *
     * @param bool $flag
     * @return Response
     */
    public function setValid($flag)
    {
        $this->isValid = (bool) $flag;
        return $this;
    }

    /**
     * Checks if response is valid (good)
     *
     * @return bool
     */
    public function isValid()
    {
        return (bool) $this->isValid;
    }

    /**
     * Set error message that should be returned to user
     *
     * @param string $error
     * @return Response
     */
    public function setError($error)
    {
        $this->error = (string) $error;
        return $this;
    }

    /**
     * Retrieve currently set error message
     *
     * @return string
     */
    public function getError()
    {
        return $this->error;
    }
}

