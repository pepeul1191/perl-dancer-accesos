package Config::Database;
use DBI;
use utf8;

sub new {
    my $class = shift;
    my $driver   = "SQLite";
    my $database = "/home/pepe/Documentos/perl/accesos/db/db_accesos.db";
    my $dsn = "DBI:$driver:dbname=$database";
    my $userid = "";
    my $password = "";
    my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1, sqlite_unicode => 1 })
                          or die $DBI::errstr;

    my $self = {
        _dbh => $dbh
    };

    bless $self, $class;
    return $self;
}

sub getConnection {
    my( $self ) = @_;
    return $self->{_dbh};
}
1;