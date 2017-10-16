package Model::Usuario;
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
    my($self) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT U.id AS id, U.usuario AS usuario, A.momento AS momento, U.correo AS correo FROM usuarios U INNER JOIN accesos A ON U.id = A.usuario_id GROUP BY U.usuario ORDER BY U.id')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub listar_usuarios {
    my($self) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT usuario FROM usuarios')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub validar {
    my($self, $usuario, $contrasenia) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ? AND contrasenia = ?')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario );
    $sth->bind_param( 2, $contrasenia );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my $rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        $rpta = $ref->{'cantidad'};
        #print("\n1\n");
        #print $rpta;
        #print("\n1\n");
    }

    $sth->finish;

    return $rpta;
}

sub obtener_id{
    my($self, $usuario, $contrasenia) = @_;
    my($self) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT id FROM usuarios WHERE usuario = ? AND contrasenia = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario );
    $sth->bind_param( 2, $contrasenia );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub listar_permisos {
    my($self, $usuario_id) = @_;
    my $sth = $self->{_dbh}->prepare('
        SELECT T.id AS id, T.nombre AS nombre, (CASE WHEN (P.existe = 1) THEN 1 ELSE 0 END) AS existe, T.llave AS llave FROM
        (
            SELECT id, nombre, llave, 0 AS existe FROM permisos
        ) T
        LEFT JOIN
        (
            SELECT P.id, P.nombre,  P.llave, 1 AS existe  FROM permisos P 
            INNER JOIN usuarios_permisos UP ON P.id = UP.permiso_id
            WHERE UP.usuario_id = ?
        ) P
        ON T.id = P.id
    ') or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub listar_roles {
    my($self, $usuario_id) = @_;
    my $sth = $self->{_dbh}->prepare('
        SELECT T.id AS id, T.nombre AS nombre, (CASE WHEN (P.existe = 1) THEN 1 ELSE 0 END) AS existe FROM
        (
            SELECT id, nombre, 0 AS existe FROM roles 
        ) T
        LEFT JOIN
        (
            SELECT R.id, R.nombre, 1 AS existe  FROM roles R 
            INNER JOIN usuarios_roles UR ON R.id = UR.rol_id
            WHERE UR.usuario_id = ?
        ) P
        ON T.id = P.id
    ') or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub asociar_rol {
    my($self, $usuario_id, $rol_id) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO usuarios_roles (usuario_id, rol_id) VALUES (?, ?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->bind_param( 2, $rol_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub desasociar_rol {
    my($self, $usuario_id, $rol_id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM usuarios_roles WHERE usuario_id = ? AND rol_id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->bind_param( 2, $rol_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub asociar_permiso {
    my($self, $usuario_id, $permiso_id) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO usuarios_permisos (usuario_id, permiso_id) VALUES (?, ?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->bind_param( 2, $permiso_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub desasociar_permiso {
    my($self, $usuario_id, $permiso_id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM usuarios_permisos WHERE usuario_id = ? AND permiso_id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id);
    $sth->bind_param( 2, $permiso_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub validar_correo_repetido {
    my($self, $correo) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT COUNT(*) AS cantidad FROM usuarios WHERE correo = ?')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $correo );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my $rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        $rpta = $ref->{'cantidad'};
    }

    $sth->finish;

    return $rpta;
}

sub validar_correo_repetido_editado {
    my($self, $usuario_id, $correo) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT COUNT(*) AS cantidad FROM usuarios WHERE correo = ? AND id = ?')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $correo );
    $sth->bind_param( 2, $usuario_id );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my $rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        $rpta = $ref->{'cantidad'};
    }

    $sth->finish;

    return $rpta;
}

sub validar_usuario_repetido {
    my($self, $usuario) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ?')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my $rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        $rpta = $ref->{'cantidad'};
    }

    $sth->finish;

    return $rpta;
}

sub validar_usuario_repetido_editado {
    my($self, $usuario_id, $usuario) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ? AND id = ?')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario );
    $sth->bind_param( 2, $usuario_id );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my $rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        $rpta = $ref->{'cantidad'};
    }

    $sth->finish;

    return $rpta;
}

sub validar_contrasenia_repetida {
    my($self, $usuario_id, $contrasenia) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT COUNT(*) AS cantidad FROM usuarios WHERE contrasenia = ? AND id = ?')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $contrasenia );
    $sth->bind_param( 2, $usuario_id );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my $rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        $rpta = $ref->{'cantidad'};
    }

    $sth->finish;

    return $rpta;
}

sub obtener_usuario_correo {
    my($self, $usuario_id) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT usuario, correo FROM usuarios WHERE id = ?')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario_id );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my $rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        $rpta = $ref;
    }

    $sth->finish;

    return $rpta;
}

1;