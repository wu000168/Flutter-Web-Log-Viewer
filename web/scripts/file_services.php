<?php
chdir('..');
$logs_json = 'scripts/logs.json';
if (!file_exists($logs_json)) file_put_contents($logs_json, json_encode(array('Example Log' => array('path' => 'logs/log.txt', 'can_delete' => false, 'bak_on_delete' => true))));
function fetch_list()
{
    global $logs_json;
    return (json_decode(file_get_contents($logs_json), true));
}

function file_not_found($filename)
{
    header('HTTP/1.1 404 Not found');
    header('Content-Type: application/json; charset=UTF-8');
    die(json_encode(array('message' => 'File ' . $filename . ' Not Found')));
}

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Credentials: true');
$config = fetch_list() or array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $filename = $_GET['filename'];
    switch ($_GET['action']) {
        case 'get_content':
            header('HTTP/1.1 200 OK');
            header('Content-Type: text/plain; charset=UTF-8');
            $content = file_get_contents($config[$filename]['path']);
            if ($content === false) file_not_found($filename);
            $encoding = mb_detect_encoding($content, 'UTF-8', true);
            if ($encoding != 'UTF-8') $content = utf8_encode($content);
            echo $content;
            break;
        case 'fetch_list':
            if ($config === null) {
                if (!file_exists($logs_json)) {
                    file_not_found($logs_json);
                    file_put_contents($logs_json, json_encode(array(
                        'log.txt' =>
                        array('path' => '/var/www/http/log.txt', 'bak_on_delete' => true)
                    )));
                } else {
                    $config = array();
                }
            }
            header('HTTP/1.1 200 OK');
            header('Content-Type: application/json; charset=UTF-8');
            echo json_encode($config, JSON_FORCE_OBJECT);
            break;
        case 'clear':
            $path = $config[$filename]['path'];
            if ($config[$filename]['bak_on_delete']) {
                file_put_contents($path . '.bak', file_get_contents($path)) or die('Could not backup ' . $path);
            }
            $ret = file_put_contents($path, '') === 0 or die('Could not empty file');
            header('HTTP/1.1 200 OK');
            break;
        default:
            header('HTTP/1.1 400 Bad Request');
            header('Content-Type: application/json; charset=UTF-8');
            die(json_encode(array('message' => 'Invalid Request')));
            break;
    }
    return;
} else if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $request_body = json_decode(file_get_contents('php://input'), true);
    $filename = (array_keys($request_body))[0];
    switch ($_GET['action']) {
        case 'update_entry':
            // if (!file_exists($request_body[$filename]['path'])) file_not_found(array_key_first($filename));
            file_put_contents($logs_json, json_encode(array_merge($config, $request_body))) or die('Could not write logs.json');
            header('HTTP/1.1 200 OK');
            break;
        case 'remove_entry':
            // if (!file_exists($request_body[$filename]['path'])) file_not_found(array_key_first($filename));
            unset($config[$filename]);
            file_put_contents($logs_json, json_encode($config)) or die('Could not write logs.json');
            header('HTTP/1.1 200 OK');
            break;
        default:
            header('HTTP/1.1 400 Bad Request');
            header('Content-Type: application/json; charset=UTF-8');
            die(json_encode(array('message' => 'Invalid Request')));
            break;
    }
    return;
}
header('HTTP/1.1 400 Bad Request');
header('Content-Type: application/json; charset=UTF-8');
die(json_encode(array('message' => 'Invalid Request')));
