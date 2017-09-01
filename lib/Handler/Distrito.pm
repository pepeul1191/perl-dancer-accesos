package Handler::Distrito;
use Filter::Acl;
use Dancer2;
use REST::Client;
use Data::Dumper;

hook before => sub {
    response_header 'X-Powered-By' => 'Perl Dancer 1.3202, Ubuntu';
    #print Filter::Acl::alc(request);
  };

get '/buscar' => sub {
	my $url = config->{backend} . 'distrito/buscar?nombre=' . query_parameters->get('nombre');
	my $client = REST::Client->new();
	$client->GET($url);
    return $client->responseContent();
};

1;