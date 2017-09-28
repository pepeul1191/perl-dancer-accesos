package Model::Acceso;
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

sub crear {
    my($self, $usuario_id) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO accesos (usuario_id, momento) VALUES (?, DATETIME("now","localtime"))') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
   
    $sth->finish;
}

sub listar_accesos {
    my($self, $usuario_id) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT id, momento FROM accesos WHERE  usuario_id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

1;