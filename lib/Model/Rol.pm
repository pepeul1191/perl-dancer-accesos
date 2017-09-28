package Model::Rol;
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
    my $sth = $self->{_dbh}->prepare('SELECT id, nombre FROM roles') 
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
    my($self, $nombre) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO roles (nombre) VALUES (?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $nombre);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    
    my $id_generated = $self->{_dbh}->last_insert_id(undef, undef, undef, undef );
    $sth->finish;

    return $id_generated;
}

sub editar {
    my($self, $id, $nombre) = @_;
    my $sth = $self->{_dbh}->prepare('UPDATE roles SET nombre = ? WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $nombre);
    $sth->bind_param( 2, $id);

    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub eliminar {
    my($self, $id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM roles WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub crear_asociacion {
    my($self, $rol_id, $permiso_id) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO roles_permisos (rol_id, permiso_id) VALUES (?, ?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $rol_id);
    $sth->bind_param( 2, $permiso_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub eliminar_asociacion {
    my($self, $rol_id, $permiso_id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM roles_permisos WHERE rol_id = ? AND permiso_id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $rol_id);
    $sth->bind_param( 2, $permiso_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

1;