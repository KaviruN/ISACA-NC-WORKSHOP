<?php
$output = "";
if (isset($_GET['ip'])) {
    $ip = $_GET['ip'];
    $output = shell_exec("ping -c 1 " . $ip);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Lab 01</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        form {
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            margin-bottom: 15px;
        }
        input[type="submit"] {
            background: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background: #0056b3;
        }
        pre {
            background: #333;
            color: #0f0;
            padding: 15px;
            border-radius: 4px;
            overflow-x: auto;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <form action="index.php" method="get">
        <label for="ip">Enter the IP:</label>
        <input type="text" id="ip" name="ip" placeholder="127.0.0.1">
        <input type="submit" value="SUBMIT">
    </form>
    <?php if ($output): ?>
        <pre><?php echo $output; ?></pre>
    <?php endif; ?>
</body>
</html>
