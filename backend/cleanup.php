<?php
$dir = __DIR__ . "/images";

$files = glob("$dir/*");

foreach ($files as $file) {
    if (is_file($file)) {
            unlink($file);
    }
}


echo "Toutes les images ont été effacées.";
