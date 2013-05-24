<?php
    $dest = "/var/ftp/incoming/CRASH/";
    header("Content-type: text/plain");
    echo "Crash Vars\n";
    foreach ($_POST as $k => $v) {
        echo "$k : $v\n";
    }
    echo "Files\n";
    foreach ($_FILES as $k => $v) {
        echo "$k: ".$v['name']."\n";
        echo "$k: ".$v['type']."\n";
        echo "$k: ".$v['size']."\n";

        $base = $k == 'log' ? 'log.tar.bz2' : 'minidump.dmp';
        $file = $base;
        $count = 0;
        while (file_exists($dest.$file)) {
            $file = (++$count).'-'.$base;
        }

        echo "$k: File $dest$file\n";
        move_uploaded_file($v['tmp_name'], $dest.$file);
    }
?>