<?php
function curl($url)
{
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    // curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_CAINFO, $_SERVER['DOCUMENT_ROOT'] . '/../cacert.pem');
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_HTTPGET, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $result = curl_exec($ch);
    curl_close($ch);
    // echo $result;
    return $result;
}
// header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Credentials: true');

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $token_uri = 'https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=ww4bc16c5c2e154d95&corpsecret=5vfA8u29woGYWaKZSR_dXduplZFhz6cPB0BsP0CkZoM';
    $token_response = curl($token_uri); // or die(json_encode(array("message" => "Failed to get token")));
    $token_response_obj = json_decode($token_response, true);
    if ($token_response_obj['errcode'] != 0) {
        header('HTTP/1.1 400 Bad Request');
        die(json_encode(array_merge($token_response_obj, array('message' => 'Failed to get token: ' . $token_response['errcode'] . ' ' . $token_response['errmsg']))));
    }
    $user_uri = 'https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=' . $token_response_obj['access_token'] . '&code=' . $_GET['code'];
    $user_response = curl($user_uri); // or die(json_encode(array("message" => "Failed to get user")));
    $user_response_obj = json_decode($user_response, true);
    if ($user_response_obj['errcode'] != 0) {
        header('HTTP/1.1 400 Bad Request');
        die(json_encode(array_merge($user_response_obj, array('message' => 'Failed to get user: ' . $user_response_obj['errcode'] . ' ' . $user_response_obj['errmsg']))));
    }
    header('HTTP/1.1 200 OK');
    header('Content-Type: application/json; charset=UTF-8');
    echo json_encode($user_response_obj);
    return;
}
header('HTTP/1.1 400 Bad Request');
header('Content-Type: application/json; charset=UTF-8');
die(json_encode(array('message' => 'Invalid Request')));
