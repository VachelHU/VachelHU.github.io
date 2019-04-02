# php发送请求方法简明总结
### 用file_get_contents 以get方式获取内容：

    <?php
    $url='http://www.jb51.net/';
    $html = file_get_contents($url);
    echo $html;
    ?>


### 用fopen打开url, 以get方式获取内容：

    <?php
    $data = array ('foo' => 'bar');
    $data = http_build_query($data);

    $opts = array (
        'http' => array (
        'method' => 'POST',
        'header'=> "Content-type: application/x-www-form-urlencodedrn" .
        "Content-Length: " . strlen($data) . "rn",
        'content' => $data
      )
    );

    $context = stream_context_create($opts);
    $html = file_get_contents('http://localhost/e/admin/test.html', false, $context);

    echo $html;
    ?>


### 用fsockopen函数打开url
以get方式获取完整的数据，包括header和body

fsockopen需要 PHP.ini 中 allow_url_fopen 选项开启

    <?php
    function get_url ($url,$cookie=false)
    {
      $url = parse_url($url);
      $query = $url[path]."?".$url[query];
      echo "Query:".$query;
      $fp = fsockopen( $url[host], $url[port]?$url[port]:80 , $errno, $errstr, 30);
      if (!$fp) {
          return false;
        } else {
          $request = "GET $query HTTP/1.1rn";
          $request .= "Host: $url[host]rn";
          $request .= "Connection: Closern";
          if($cookie) $request.="Cookie:  $cookien";
          $request.="rn";
          fwrite($fp,$request);
          while(!@feof($fp)) {
            $result .= @fgets($fp, 1024);
          }
          fclose($fp);
          return $result;
        }
      }
      //获取url的html部分，去掉header
      function GetUrlHTML($url,$cookie=false)
      {
        $rowdata = get_url($url,$cookie);
        if($rowdata)
        {
          $body= stristr($rowdata,"rnrn");
          $body=substr($body,4,strlen($body));
          return $body;
        }

        return false;
      }
    ?>


### 用fsockopen函数打开url
以POST方式获取完整的数据，包括header和body

    <?php
    function HTTP_Post($URL,$data,$cookie, $referrer="")
    {

      // parsing the given URL
      $URL_Info=parse_url($URL);

      // Building referrer
      if($referrer=="") // if not given use this script as referrer
      $referrer="111″;

      // making string from $data
      foreach($data as $key=>$value)
      $values[]="$key=".urlencode($value);
      $data_string=implode(“&",$values);

      // Find out which port is needed – if not given use standard (=80)
      if(!isset($URL_Info["port"]))
        $URL_Info["port"]=80;

      // building POST-request:
      $request.="POST “.$URL_Info["path"]." HTTP/1.1n";
      $request.="Host: “.$URL_Info["host"]."n";
      $request.="Referer: $referern";
      $request.="Content-type: application/x-www-form-urlencodedn";
      $request.="Content-length: “.strlen($data_string)."n";
      $request.="Connection: closen";

      $request.="Cookie:  $cookien";

      $request.="n";
      $request.=$data_string."n";

      $fp = fsockopen($URL_Info["host"],$URL_Info["port"]);
      fputs($fp, $request);
      while(!feof($fp)) {
        $result .= fgets($fp, 1024);
      }
      fclose($fp);

      return $result;
    }

    ?>

### 使用curl库
使用curl库之前，可能需要查看一下php.ini是否已经打开了curl扩展

    <?php
    $ch = curl_init();
    $timeout = 5;
    curl_setopt ($ch, CURLOPT_URL, 'http://www.jb51.net/');
    curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
    $file_contents = curl_exec($ch);
    curl_close($ch);

    echo $file_contents;
    ?>

### 注：mac修改php.ini的方法
在`/private/etc/php.ini`目录下
