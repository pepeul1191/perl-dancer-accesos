package Model::Modulo;
use Config::Database;

sub new {
    my $class = shift;
    my $db = 'Config::Database';
    my $odb= $db->new();
    my $dbh = $odb->getConnection();
    $dbh->do("PRAGMA foreign_keys = ON");
    my $self = {
        _dbh => $dbh
    };

    bless $self, $class;
    return $self;
}

sub listar {
    my($self) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT id, url, nombre FROM modulos') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub crear {
    my($self, $url, $nombre) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO modulos (url, nombre) VALUES (?, ?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $url);
    $sth->bind_param( 2, $nombre);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    
    my $id_generated = $self->{_dbh}->last_insert_id(undef, undef, undef, undef );
    $sth->finish;

    return $id_generated;
}

sub editar {
    my($self, $id, $url, $nombre) = @_;
    my $sth = $self->{_dbh}->prepare('UPDATE modulos SET url = ?, nombre = ? WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $url);
    $sth->bind_param( 2, $nombre);
    $sth->bind_param( 3, $id);

    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub eliminar {
    my($self, $id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM modulos WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

1;