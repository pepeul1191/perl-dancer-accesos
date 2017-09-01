package Handler::App;
use Dancer2;
use Data::Dumper;
use JSON::Create 'create_json';

our $VERSION = '0.1';

hook before => sub {
    response_header 'X-Powered-By' => 'Perl Dancer 1.3202, Ubuntu';
  };

get '/' => sub {
	my $thing = {'Yes' => true, 'No' => false};

	my %context = (
        'title'  => 'Animalitos Perl',
        'menu' => '[{"url":"#/","nombre":"Home"},{"url":"#/buscar","nombre":"Buscar"},{"url":"#/contacto","nombre":"Contacto"}]',
        'data'  => '""',
    );
    template 'animalitos/index.tt', {%context}, { layout => 'site.tt' };
};

get '/hola' => sub {
    return 'hola mundo!';
};

sub alc {
	my ($rq) = @_;
	print("1 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
	$rq.redirect('http://softweb.pe');
	print("2 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
	return 'true';
}

1;
