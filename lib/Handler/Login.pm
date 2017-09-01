package Handler::Login;
use Filter::Acl;
use Dancer2;

hook before => sub {
    response_header 'X-Powered-By' => 'Perl Dancer 1.3202, Ubuntu';
    print Filter::Acl::alc(request);
  };

get '/' => sub {
	#redirect 'http://softweb.pe/';
    return 'login';
};

get '/anda' => sub {
    return 'anda';
};

post '/acceder' => sub {
    return 'accedersh';
};

1;
