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

1;