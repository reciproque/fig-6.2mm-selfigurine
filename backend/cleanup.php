<?php
$dir = __DIR__ . "/images";
$days = 7;

$now = time();
$files = glob("$dir/*");

foreach ($files as $file) {
    if (is_file($file)) {
        if ($now - filemtime($file) > ($days * 86400)) {
            unlink($file);
        }
    }
}

echo "Cleanup done.";
