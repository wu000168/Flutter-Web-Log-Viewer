<?php

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Credentials: true');

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $token_uri = 'https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=ww558b222409b5625f&corpsecret=7YNh3aUeumBR9d7RLB9FcDhR25TIqxY3nPCXgLhgbpA';
    $token_header = get_headers($token_uri);
    if ($token_header[0] != 'HTTP/1.1 200 OK') {
        foreach ($token_header as $header) {
            header(header);
            header('Content-Type: application/json');
            die(json_encode(array('message' => 'Failed to get token')));
        }
    }
    $token_response = json_decode(file_get_contents($token_uri));
    if ($token_response['errcode'] != 0) {
        header('HTTP/1.1 400 Bad Request');
        die(json_encode(array_merge($token_response, array('message' => 'Failed to get token: ' . $token_response['errcode'] . ' ' . $token_response['errmsg']))));
    }
    $user_uri = 'https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=' . $token_response['access_token'] . '&code=' . $_GET['code'];
    $user_header = get_headers($user_uri);
    if ($user_header[0] != 'HTTP/1.1 200 OK') {
        foreach ($user_header as $header) {
            header(header);
            header('Content-Type: application/json');
            die(json_encode(array('message' => 'Failed to get user')));
        }
    }
    $user_response = json_decode(file_get_contents($user_uri));
    if ($token_response['errcode'] != 0) {
        header('HTTP/1.1 400 Bad Request');
        die(json_encode(array_merge($user_response, array('message' => 'Failed to get user: ' . $token_response['errcode'] . ' ' . $token_response['errmsg']))));
    }
    header('HTTP/1.1 200 OK');
    header('Content-Type: application/json; charset=UTF-8');
    echo json_encode($user_response);
    return;
}
header('HTTP/1.1 400 Bad Request');
header('Content-Type: application/json; charset=UTF-8');
die(json_encode(array('message' => 'Invalid Request')));
