#!/usr/bin/perl 
##-- |----------------------------------------------------------------------------|
##-- | Criado por : Roberto Fernandes Sobrinho                                    |
##-- | Data       : 15/02/2020                                                    |
##-- | Exemplo    : perl CASE_10_CONN_[OK]_COMM_[OK]_BIND_[OK]_100_insert.pl 100  |
##-- | Modificacao:                                                               |
##-- +----------------------------------------------------------------------------+
##DROP TABLE TABLE scott.TBL_RFS_1Q2W3E4R
##CREATE TABLE scott.TBL_RFS_1Q2W3E4R (SEQ NUMBER,NAME VARCHAR2(20),DATA DATE);
##CREATE INDEX scott.TBL_RFS_1Q2W3E4R_I01 ON scott.TBL_RFS_1Q2W3E4R ( SEQ );
##-- +----------------------------------------------------------------------------+
use strict;
use warnings;
use Time::HiRes qw(time);
use DBD::Oracle qw(:ora_session_modes);

##print time(), "\n";             # 1530190722.02601 for example

my $quantidade = $ARGV[0];
my $oracle_hostname = 'localhost';
my $oracle_database = 'orcl';
my $oracle_username = 'scott';
my $oracle_password = 'tiger';
my $tps      =  0;
my $duration =  0;
my $start = time;
##my $oracle_dbh = DBI->connect("dbi:Oracle:host=$oracle_hostname;service_name=$oracle_database", $oracle_username, $oracle_password, {RaiseError => 1, AutoCommit => 1});

sub create_TBL_RFS {
my $oracle_dbh = DBI->connect("dbi:Oracle:host=$oracle_hostname;service_name=$oracle_database", $oracle_username, $oracle_password, {RaiseError => 1, AutoCommit => 1});
my $oracle_sql = "CREATE TABLE scott.TBL_RFS_1Q2W3E4R (SEQ NUMBER,NAME VARCHAR2(20),DATA DATE) TABLESPACE SYSTEM";
my $oracle_sth = $oracle_dbh->prepare($oracle_sql) or die $DBI::errstr;
$oracle_sth->execute() or die $DBI::errstr;
$oracle_dbh->disconnect;
}

sub trunc_TBL_RFS {
my $oracle_dbh = DBI->connect("dbi:Oracle:host=$oracle_hostname;service_name=$oracle_database", $oracle_username, $oracle_password, {RaiseError => 1, AutoCommit => 1});
my $oracle_sql = "truncate table scott.TBL_RFS_1Q2W3E4R";
my $oracle_sth = $oracle_dbh->prepare($oracle_sql) or die $DBI::errstr;
$oracle_sth->execute() or die $DBI::errstr;
$oracle_dbh->disconnect;
}
################################################
##TESE 01
################################################
trunc_TBL_RFS();
$start = time;
for (my $numero = 1; $numero < $quantidade; $numero++)
	{
	my $oracle_dbh = DBI->connect("dbi:Oracle:host=$oracle_hostname;service_name=$oracle_database", $oracle_username, $oracle_password, {RaiseError => 1, AutoCommit => 1});
	my $oracle_sql = "INSERT /*F-NOK-NOK-NOK*/ INTO scott.TBL_RFS_1Q2W3E4R (SEQ,NAME,DATA) VALUES ($numero,DBMS_RANDOM.string('x',10), SYSDATE)";
	my $oracle_sth = $oracle_dbh->prepare($oracle_sql) or die $DBI::errstr;
	$oracle_sth->execute() or die $DBI::errstr;
	$oracle_dbh->disconnect;
	}
$duration = sprintf("%.5f",(time() - $start));     
 if ($duration > 0) {
    $tps = sprintf("%.4f",($quantidade/$duration));
} else {
    $tps = sprintf("%.4f",$quantidade);
}
##$duration = sprintf("%05d",$duration);
print("=================================================================================================INSERTS[$quantidade]\n"); 
print("CASE 01 - CONNECT: NOK    COMMIT : NOK    BINDS: NOK        TIME(s): $duration    TPS: $tps   \n"); 
print("========================================================================================================\n"); 
exit;
