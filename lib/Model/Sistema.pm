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

sub usuario {
    my($self, $usuario_id) = @_;
    my $sth = $self->{_dbh}->prepare('
        SELECT T.id AS id, T.nombre AS nombre, (CASE WHEN (P.existe = 1) THEN 1 ELSE 0 END) AS existe FROM
        (
            SELECT id, nombre, 0 AS existe FROM sistemas
        ) T
        LEFT JOIN
        (
            SELECT S.id, S.nombre, 1 AS existe FROM sistemas S
            INNER JOIN usuarios_sistemas US ON US.sistema_id = S.id
            WHERE US.usuario_id = ?
        ) P
        ON T.id = P.id') or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub usuario_asociado {
    my($self, $usuario_id) = @_;
    my $sth = $self->{_dbh}->prepare('
        SELECT S.id, S.nombre FROM sistemas S INNER JOIN 
        usuarios_sistemas US ON S.id = US.sistema_id 
        WHERE US.usuario_id = ?') or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub crear_asociacion {
    my($self, $usuario_id, $sistema_id) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO usuarios_sistemas (usuario_id, sistema_id) VALUES (?, ?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->bind_param( 2, $sistema_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub eliminar_asociacion {
    my($self, $usuario_id, $sistema_id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM usuarios_sistemas WHERE usuario_id = ? AND sistema_id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->bind_param( 2, $sistema_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

1;