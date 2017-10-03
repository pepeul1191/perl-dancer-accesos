package Model::Sistema;
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
    my $sth = $self->{_dbh}->prepare('SELECT id, nombre, version, repositorio FROM sistemas') 
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
    my($self, $nombre, $version, $repositorio) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO sistemas (nombre, version, repositorio) VALUES (?, ?, ?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $nombre);
    $sth->bind_param( 2, $version);
    $sth->bind_param( 3, $repositorio);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    
    my $id_generated = $self->{_dbh}->last_insert_id(undef, undef, undef, undef );
    $sth->finish;

    return $id_generated;
}

sub editar {
    my($self, $id, $nombre, $version, $repositorio) = @_;
    my $sth = $self->{_dbh}->prepare('UPDATE sistemas SET nombre = ?, version = ? , repositorio = ? WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $nombre);
    $sth->bind_param( 2, $version);
    $sth->bind_param( 3, $repositorio);
    $sth->bind_param( 4, $id);
    
    print("\n1 +++++++++++++++++++++++++++++++++++++++++\n");
    print($id);
    print($nombre);
    print($version);
    print($repositorio);
    print("\n2 +++++++++++++++++++++++++++++++++++++++++\n");

    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub eliminar {
    my($self, $id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM sistemas WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

1;