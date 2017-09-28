package Model::Subtitulo;
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
    my($self, $modulo_id) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT id, nombre FROM subtitulos WHERE  modulo_id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $modulo_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub crear {
    my($self, $modulo_id, $nombre) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO subtitulos (modulo_id, nombre) VALUES (?, ?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $modulo_id);
    $sth->bind_param( 2, $nombre);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    
    my $id_generated = $self->{_dbh}->last_insert_id(undef, undef, undef, undef );
    $sth->finish;

    return $id_generated;
}

sub editar {
    my($self, $id, $modulo_id, $nombre) = @_;
    my $sth = $self->{_dbh}->prepare('UPDATE subtitulos SET modulo_id = ?, nombre = ? WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $modulo_id);
    $sth->bind_param( 2, $nombre);
    $sth->bind_param( 3, $id);

    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub eliminar {
    my($self, $id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM subtitulos WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

1;