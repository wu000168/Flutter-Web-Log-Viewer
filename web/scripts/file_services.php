<?php
$logs_json = 'scripts/logs.json';
chdir('..');

function fetch_list()
{
    return (json_decode(file_get_contents('./scripts/logs.json'), true));
}

function file_not_found($filename)
{
    header('HTTP/1.1 404 Not found');
    header('Content-Type: application/json; charset=UTF-8');
    die(json_encode(array('message' => 'File ' . $filename . ' Not Found')));
}

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Credentials: true');
$config = fetch_list();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $filename = $_GET['filename'];
    switch ($_GET['action']) {
        case 'get_content':
            header('HTTP/1.1 200 OK');
            header('Content-Type: text/plain; charset=UTF-8');
            $content = file_get_contents($config[$filename]['path']) or file_not_found($filename);
            echo utf8_encode($content);
            break;
        case 'fetch_list':
            if ($config == null) {
                file_not_found('logs.json');
                file_put_contents($logs_json, json_encode(array(
                    'log.txt' =>
                    array('path' => '/var/www/http/log.txt', 'bak_on_delete' => true)
                )));
            }
            header('HTTP/1.1 200 OK');
            header('Content-Type: application/json; charset=UTF-8');
            echo json_encode($config);
            break;
        case 'clear':
            $path = $config[$filename]['path'];
            if ($config[$filename]['bak_on_delete']) {
                unlink($path . '.bak') or die('Could not delete ' . $path . '.bak');
                rename($path, $path . '.bak') or die('Could not rename ' . $path);
                file_put_contents($path, '') or die('Could not create new empty file');
            } else {
                file_put_contents($path, '') or die('Could not empty file');
            }
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
    $filename = array_key_first($request_body);
    switch ($_POST['action']) {
        case 'add_file':
            if (!file_exists($request_body[$filename]['path'])) file_not_found(array_key_first($filename));
            file_put_contents($logs_json, array_merge($config, $request_body)) or die('Could not write logs.json');
            header('HTTP/1.1 200 OK');
            break;
        case 'remove_entry':
            if (!file_exists($request_body[$filename]['path'])) file_not_found(array_key_first($filename));
            unset($config[$filename]);
            file_put_contents($logs_json, $config) or die('Could not write logs.json');
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
