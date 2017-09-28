package Model::EstadoUsuario;
use Config::Database;

sub new {
    my $class = shift;
    my $db = 'Config::Database';
  	my $odb= $db->new();
  	my $dbh = $odb->getConnection();
    my $self = {
        _dbh => $dbh
    };

    bless $self, $class;
    return $self;
}

sub listar {
    my($self, $subtitulo_id) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT id, nombre FROM estado_usuarios;') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}
1;