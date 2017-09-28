package Model::Item;
use Config::Database;
use utf8;
binmode STDOUT, ":encoding(utf8)";

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

sub menu {
    my($self, $nombreModulo) = @_;
    my $sth = $self->{_dbh}->prepare('
            SELECT I.nombre AS item, I.url, S.nombre AS subtitulo FROM items I 
            INNER JOIN subtitulos S ON I.subtitulo_id = S.id
            INNER JOIN modulos M ON S.modulo_id = M.id
            WHERE M.nombre = ?
        ') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $nombreModulo );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub listar_todos {
    my($self) = @_;
    my $sth = $self->{_dbh}->prepare("
            SELECT M.nombre AS modulo , M.icono AS icono,S.nombre AS subtitulo,
            GROUP_CONCAT(I.nombre || '::' || I.url, '||') AS items
            FROM items I 
            INNER JOIN subtitulos S ON I.subtitulo_id = S.id
            INNER JOIN modulos M ON S.modulo_id = M.id
            GROUP BY subtitulo
            ORDER BY modulo
        ") 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub listar {
    my($self, $subtitulo_id) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT id, nombre, url FROM items WHERE  subtitulo_id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $subtitulo_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub crear {
    my($self, $subtitulo_id, $nombre, $url) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO items (subtitulo_id, nombre, url) VALUES (?, ?, ?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $subtitulo_id);
    $sth->bind_param( 2, $nombre);
    $sth->bind_param( 3, $url);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    
    my $id_generated = $self->{_dbh}->last_insert_id(undef, undef, undef, undef );
    $sth->finish;

    return $id_generated;
}

sub editar {
    my($self, $id, $subtitulo_id, $nombre, $url) = @_;
    my $sth = $self->{_dbh}->prepare('UPDATE items SET subtitulo_id = ?, nombre = ?, url = ? WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $subtitulo_id);
    $sth->bind_param( 2, $nombre);
    $sth->bind_param( 3, $url);
    $sth->bind_param( 4, $id);

    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub eliminar {
    my($self, $id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM items WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

1;