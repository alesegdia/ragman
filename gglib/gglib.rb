$gglroot = File.expand_path(File.dirname(__FILE__))

$theme_init_hook = Proc.new { }

require $gglroot+"/carray"
require $gglroot+"/tile"
require $gglroot+"/image"
require $gglroot+"/camera"
require $gglroot+"/widget"
require $gglroot+"/state"
require $gglroot+"/mouse"
require $gglroot+"/window"
require $gglroot+"/theme"