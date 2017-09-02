package Handler::Registro;
use Filter::Acl;
use Dancer2;
use REST::Client;
use Data::Dumper;

hook before => sub {
  response_header 'X-Powered-By' => 'Perl Dancer 1.3202, Ubuntu';
  #print Filter::Acl::alc(request);
};

post '/validar_usuario_repetido' => sub {
		my $url = config->{backend} . 'usuario/nombre_repetido?usuario=' . query_parameters->get('nombre');
		my $client = REST::Client->new();
		$client->POST($url);
	 return $client->responseContent();
};

post '/validar_correo_repetido' => sub {
		my $url = config->{backend} . 'usuario/correo_repetido?correo=' . query_parameters->get('correo');
		my $client = REST::Client->new();
		$client->POST($url);
	 return $client->responseContent();
};

1;