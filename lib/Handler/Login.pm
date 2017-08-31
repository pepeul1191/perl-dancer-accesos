package Handler::Login;
use Dancer2;

hook before => sub {
    response_header 'X-Powered-By' => 'Perl Dancer 1.3202, Ubuntu';
  };

get '/anda' => sub {
	#response_header 'X-Powered-By' => 'Perl Dancer 1.3202';
    return 'hola mundo!';
};

get '/' => sub {
	#response_header 'X-Powered-By' => 'Perl Dancer 1.3202';
    return 'hola mundo!';
};

true;
