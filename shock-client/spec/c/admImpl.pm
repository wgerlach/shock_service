package admImpl;
#use strict;
use lib qw(/Volumes/KBase/KBase.app/runtime/lib/perl5/site_perl/5.12.4
	   /Users/brettin/local/dev/readonly/typecomp/lib);
use Bio::KBase::Exceptions;

=head1 NAME

adm

=head1 DESCRIPTION



=cut

#BEGIN_HEADER
use LWP::UserAgent;
use SystemProperties;
use HTTP::Headers;
use HTTP::Request::Common;
use JSON -support_by_pp;
use Data::Dumper;
#END_HEADER

sub new
  {
    my($class, @args) = @_;
    my $self = {
	     };
    bless $self, $class;

    #BEGIN_CONSTRUCTOR
    
    # create a system properties object and get the address of shock server
    $self->{sys_prop} = SystemProperties->new();
    $self->{shock_url} = 'http://' . $self->{sys_prop}->get('shockAddr');
    print "setting shock_url to ", $self->{shock_url}, "\n";
    $self->{ua} = LWP::UserAgent->new();

    #END_CONSTRUCTOR
    
    if ($self->can('_init_instance'))
      {
	$self->_init_instance();
      }
    return $self;
  }

=head1 METHODS



=head2 createUser

  $u = $obj->createUser($n, $p)

=over 4

=item Parameter and return types

=begin html

<pre>
$n is a Username
$p is a Password
$u is a User
Username is a string
Password is a string
User is a reference to a hash where the following keys are defined:
	D has a value which is a Userdata
	E has a value which is an Error
	S has a value which is a Httpcode
Userdata is a reference to a hash where the following keys are defined:
	uuid has a value which is an Uuid
	name has a value which is a Username
	passwd has a value which is a Password
	admin has a value which is a Boolean
Uuid is a string
Boolean is an int
Error is a string
Httpcode is an int

</pre>

=end html

=begin text

$n is a Username
$p is a Password
$u is a User
Username is a string
Password is a string
User is a reference to a hash where the following keys are defined:
	D has a value which is a Userdata
	E has a value which is an Error
	S has a value which is a Httpcode
Userdata is a reference to a hash where the following keys are defined:
	uuid has a value which is an Uuid
	name has a value which is a Username
	passwd has a value which is a Password
	admin has a value which is a Boolean
Uuid is a string
Boolean is an int
Error is a string
Httpcode is an int


=end text



=item Description

Create a user

=back

=cut

sub createUser
  {
    my $self = shift;
    my($n, $p) = @_;

    my @_bad_arguments;
    (!ref($n)) or push(@_bad_arguments, "Invalid type for argument \"n\" (value was \"$n\")");
    (!ref($p)) or push(@_bad_arguments, "Invalid type for argument \"p\" (value was \"$p\")");
    if (@_bad_arguments) {
      my $msg = "Invalid arguments passed to createUser:\n" . join("", map { "\t$_\n" } @_bad_arguments);
      Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							     method_name => 'createUser');
    }
    
    my $ctx = $admServer::CallContext;
    my($u);



    #BEGIN createUser

    my ($header, $request, $method, $uri, $response);
    $method = 'POST';
    $uri = $self->{shock_url} . "/user";
    
    # create the header
    $header = HTTP::Headers->new;
    $header->header('Content-Type' => 'text/plain');	
    $header->header('Host' => $uri);
    $header->authorization_basic($n, $p);

    # create the request
    $request = HTTP::Request->new( $method, $uri, $header );

    # send the request
    $response = $self->{ua}->request($request);
    if ($response->is_success) {
      # print Dumper($response);

      # parse the results
      my $json = JSON->new()->allow_nonref();
      $u = $json->decode($response->decoded_content);
    }
    else {
      my ($package, $filename, $line) = caller;
      $u = "request failed at $package in $filename at $line " 
	. "with response status " . $response->status_line;		
    }
    
    #END createUser



    my @_bad_returns;
    (ref($u) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"u\" (value was \"$u\")");
    if (@_bad_returns) {
      my $msg = "Invalid returns passed to createUser:\n" . join("", map { "\t$_\n" } @_bad_returns);
      Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							     method_name => 'createUser');
    }
    return($u);
  }




=head2 createNode

  $n = $obj->createNode($n, $p, $np)

=over 4

=item Parameter and return types

=begin html

<pre>
$n is a Username
$p is a Password
$np is a Nodeparams
$n is a Node
Username is a string
Password is a string
Nodeparams is a reference to a hash where the following keys are defined:
	attr has a value which is a string
	file has a value which is a string
Node is a reference to a hash where the following keys are defined:
	D has a value which is a Nodedata
	E has a value which is an Error
	S has a value which is a Httpcode
Nodedata is a reference to a hash where the following keys are defined:
	id has a value which is an Identifier
	file has a value which is a File
	attributes has a value which is an Attributes
	acl has a value which is an Acl
	indexes has a value which is an Index
	version has a value which is a Version
	version_parts has a value which is a VersionParts
Identifier is a string
File is a reference to a hash where the following keys are defined:
	checksum has a value which is a Fingerprint
	name has a value which is a Filename
	size has a value which is a Filesize
Fingerprint is a reference to a hash where the following keys are defined:
	md5 has a value which is a string
	sha1 has a value which is a string
Filename is a string
Filesize is an int
Attributes is a string
Acl is a reference to a hash where the following keys are defined:
	delete has a value which is a Delete
	read has a value which is a Read
	write has a value which is a Write
Delete is a reference to a list where each element is an Uuid
Uuid is a string
Read is a reference to a list where each element is an Uuid
Write is a reference to a list where each element is an Uuid
Index is a reference to a hash where the following keys are defined:
	index_type has a value which is an Indextype
	filename has a value which is a Filename
	checksum_type has a value which is a Checksumtype
	version has a value which is a Version
	index has a value which is an IndexLocations
Version is a string
VersionParts is a reference to a hash where the following keys are defined:
	acl_ver has a value which is an AclVersion
	attributes_ver has a value which is an AttributesVersion
	file_ver has a value which is a FileVersion
AclVersion is a string
AttributesVersion is a string
FileVersion is a string
Error is a string
Httpcode is an int

</pre>

=end html

=begin text

$n is a Username
$p is a Password
$np is a Nodeparams
$n is a Node
Username is a string
Password is a string
Nodeparams is a reference to a hash where the following keys are defined:
	attr has a value which is a string
	file has a value which is a string
Node is a reference to a hash where the following keys are defined:
	D has a value which is a Nodedata
	E has a value which is an Error
	S has a value which is a Httpcode
Nodedata is a reference to a hash where the following keys are defined:
	id has a value which is an Identifier
	file has a value which is a File
	attributes has a value which is an Attributes
	acl has a value which is an Acl
	indexes has a value which is an Index
	version has a value which is a Version
	version_parts has a value which is a VersionParts
Identifier is a string
File is a reference to a hash where the following keys are defined:
	checksum has a value which is a Fingerprint
	name has a value which is a Filename
	size has a value which is a Filesize
Fingerprint is a reference to a hash where the following keys are defined:
	md5 has a value which is a string
	sha1 has a value which is a string
Filename is a string
Filesize is an int
Attributes is a string
Acl is a reference to a hash where the following keys are defined:
	delete has a value which is a Delete
	read has a value which is a Read
	write has a value which is a Write
Delete is a reference to a list where each element is an Uuid
Uuid is a string
Read is a reference to a list where each element is an Uuid
Write is a reference to a list where each element is an Uuid
Index is a reference to a hash where the following keys are defined:
	index_type has a value which is an Indextype
	filename has a value which is a Filename
	checksum_type has a value which is a Checksumtype
	version has a value which is a Version
	index has a value which is an IndexLocations
Version is a string
VersionParts is a reference to a hash where the following keys are defined:
	acl_ver has a value which is an AclVersion
	attributes_ver has a value which is an AttributesVersion
	file_ver has a value which is a FileVersion
AclVersion is a string
AttributesVersion is a string
FileVersion is a string
Error is a string
Httpcode is an int


=end text



=item Description

Create a node

=back

=cut

sub createNode
{
    my $self = shift;
    my($n, $p, $np) = @_;

    my @_bad_arguments;
    (!ref($n)) or push(@_bad_arguments, "Invalid type for argument \"n\" (value was \"$n\")");
    (!ref($p)) or push(@_bad_arguments, "Invalid type for argument \"p\" (value was \"$p\")");
    (ref($np) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"np\" (value was \"$np\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to createNode:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'createNode');
    }

    my $ctx = $admServer::CallContext;
    my($n);
    #BEGIN createNode

    my ($header, $request, $uri, $form_ref, $response);

    # create the uri
    $uri = $self->{shock_url} . "/node";
    
    # create the header
    $header = HTTP::Headers->new;
    $header->header('Content-Type' => 'multipart/form-data');	
    $header->header('Host' => $uri);
    $header->authorization_basic($n, $p);

    # create the request THIS IS NOT GOING TO WORK IN CLIENT/SERVER MODE
    # but should work in CLIENT MODE.

    if (ref($np) eq "HASH" and defined $np->{attributes} ) {
      # check we have a filename with full path informatin
      warn "file $np->{attributes} does not exist" unless -e $np->{attributes};
      push @$form_ref, ['attributes' => [$np->{'attributes'}]];
    }
    if (ref($np) eq "HASH" and defined $np->{'file'} ) {
      # check we have a filename with full path information
      warn "file $np->{file} does not exist" unless -e $np->{'file'};
      push @$form_ref, ['file' => [$np->{'file'}]];
    }

    # send the request
    if (defined $form_ref and @$form_ref > 0) {
      $request = HTTP::Request->new( POST $uri, $form_ref, $header);
    }
    else {
      $request = HTTP::Request->new( POST $uri, $header );
    }

    # send the request
    $response = $self->{ua}->request($request);
    # print Dumper($response);

    # parse the results
    if ($response->is_success) {
      my $json = JSON->new()->allow_nonref();
      $u = $json->decode($response->decoded_content);
    }
    else {
      my ($package, $filename, $line) = caller;
      $u = "request failed at $package in $filename at $line " 
	. "with response status " . $response->status_line;		
    }

    #END createNode
    my @_bad_returns;
    (ref($n) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"n\" (value was \"$n\")");
    if (@_bad_returns) {
      my $msg = "Invalid returns passed to createNode:\n" . join("", map { "\t$_\n" } @_bad_returns);
      Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							     method_name => 'createNode');
    }
    return($n);
  }




=head2 modifyNode

  $n = $obj->modifyNode($n, $p, $np)

=over 4

=item Parameter and return types

=begin html

<pre>
$n is a Username
$p is a Password
$np is a Nodeparams
$n is a Node
Username is a string
Password is a string
Nodeparams is a reference to a hash where the following keys are defined:
	attr has a value which is a string
	file has a value which is a string
Node is a reference to a hash where the following keys are defined:
	D has a value which is a Nodedata
	E has a value which is an Error
	S has a value which is a Httpcode
Nodedata is a reference to a hash where the following keys are defined:
	id has a value which is an Identifier
	file has a value which is a File
	attributes has a value which is an Attributes
	acl has a value which is an Acl
	indexes has a value which is an Index
	version has a value which is a Version
	version_parts has a value which is a VersionParts
Identifier is a string
File is a reference to a hash where the following keys are defined:
	checksum has a value which is a Fingerprint
	name has a value which is a Filename
	size has a value which is a Filesize
Fingerprint is a reference to a hash where the following keys are defined:
	md5 has a value which is a string
	sha1 has a value which is a string
Filename is a string
Filesize is an int
Attributes is a string
Acl is a reference to a hash where the following keys are defined:
	delete has a value which is a Delete
	read has a value which is a Read
	write has a value which is a Write
Delete is a reference to a list where each element is an Uuid
Uuid is a string
Read is a reference to a list where each element is an Uuid
Write is a reference to a list where each element is an Uuid
Index is a reference to a hash where the following keys are defined:
	index_type has a value which is an Indextype
	filename has a value which is a Filename
	checksum_type has a value which is a Checksumtype
	version has a value which is a Version
	index has a value which is an IndexLocations
Version is a string
VersionParts is a reference to a hash where the following keys are defined:
	acl_ver has a value which is an AclVersion
	attributes_ver has a value which is an AttributesVersion
	file_ver has a value which is a FileVersion
AclVersion is a string
AttributesVersion is a string
FileVersion is a string
Error is a string
Httpcode is an int

</pre>

=end html

=begin text

$n is a Username
$p is a Password
$np is a Nodeparams
$n is a Node
Username is a string
Password is a string
Nodeparams is a reference to a hash where the following keys are defined:
	attr has a value which is a string
	file has a value which is a string
Node is a reference to a hash where the following keys are defined:
	D has a value which is a Nodedata
	E has a value which is an Error
	S has a value which is a Httpcode
Nodedata is a reference to a hash where the following keys are defined:
	id has a value which is an Identifier
	file has a value which is a File
	attributes has a value which is an Attributes
	acl has a value which is an Acl
	indexes has a value which is an Index
	version has a value which is a Version
	version_parts has a value which is a VersionParts
Identifier is a string
File is a reference to a hash where the following keys are defined:
	checksum has a value which is a Fingerprint
	name has a value which is a Filename
	size has a value which is a Filesize
Fingerprint is a reference to a hash where the following keys are defined:
	md5 has a value which is a string
	sha1 has a value which is a string
Filename is a string
Filesize is an int
Attributes is a string
Acl is a reference to a hash where the following keys are defined:
	delete has a value which is a Delete
	read has a value which is a Read
	write has a value which is a Write
Delete is a reference to a list where each element is an Uuid
Uuid is a string
Read is a reference to a list where each element is an Uuid
Write is a reference to a list where each element is an Uuid
Index is a reference to a hash where the following keys are defined:
	index_type has a value which is an Indextype
	filename has a value which is a Filename
	checksum_type has a value which is a Checksumtype
	version has a value which is a Version
	index has a value which is an IndexLocations
Version is a string
VersionParts is a reference to a hash where the following keys are defined:
	acl_ver has a value which is an AclVersion
	attributes_ver has a value which is an AttributesVersion
	file_ver has a value which is a FileVersion
AclVersion is a string
AttributesVersion is a string
FileVersion is a string
Error is a string
Httpcode is an int


=end text



=item Description

Modify a node.

=back

=cut

sub modifyNode
  {
    my $self = shift;
    my($n, $p, $np) = @_;

    my @_bad_arguments;
    (!ref($n)) or push(@_bad_arguments, "Invalid type for argument \"n\" (value was \"$n\")");
    (!ref($p)) or push(@_bad_arguments, "Invalid type for argument \"p\" (value was \"$p\")");
    (ref($np) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"np\" (value was \"$np\")");
    if (@_bad_arguments) {
      my $msg = "Invalid arguments passed to modifyNode:\n" . join("", map { "\t$_\n" } @_bad_arguments);
      Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							     method_name => 'modifyNode');
    }

    my $ctx = $admServer::CallContext;
    my($n);

    #BEGIN modifyNode
    # The logic for this assumes that a node already exists. A node becomes
    # immutable when the file attribute and the data attribute have been set.

    my ($method, $header, $request, $uri, $form_ref, $response);
    $method = 'PUT';

    # create the uri
    $uri = $self->{shock_url} . "/node";
    
    # create the header
    $header = HTTP::Headers->new;
    $header->header('Content-Type' => 'multipart/form-data');	
    $header->header('Host' => $uri);
    $header->authorization_basic($n, $p);

    # create the request
    # START HERE WHEN CONTINUING. DONT FORGET TO DOCUMENT THE PATTERN
    $request = HTTP::Request->new();
    # send the request

    # parse the response


    #END modifyNode

    my @_bad_returns;
    (ref($n) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"n\" (value was \"$n\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to modifyNode:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'modifyNode');
    }
    return($n);
}




=head2 listNodes

  $nodes = $obj->listNodes($n, $p, $sp)

=over 4

=item Parameter and return types

=begin html

<pre>
$n is a Username
$p is a Password
$sp is a Searchparams
$nodes is a reference to a list where each element is a Node
Username is a string
Password is a string
Searchparams is a reference to a hash where the following keys are defined:
	skip has a value which is an int
	limit has a value which is an int
	query has a value which is a string
Node is a reference to a hash where the following keys are defined:
	D has a value which is a Nodedata
	E has a value which is an Error
	S has a value which is a Httpcode
Nodedata is a reference to a hash where the following keys are defined:
	id has a value which is an Identifier
	file has a value which is a File
	attributes has a value which is an Attributes
	acl has a value which is an Acl
	indexes has a value which is an Index
	version has a value which is a Version
	version_parts has a value which is a VersionParts
Identifier is a string
File is a reference to a hash where the following keys are defined:
	checksum has a value which is a Fingerprint
	name has a value which is a Filename
	size has a value which is a Filesize
Fingerprint is a reference to a hash where the following keys are defined:
	md5 has a value which is a string
	sha1 has a value which is a string
Filename is a string
Filesize is an int
Attributes is a string
Acl is a reference to a hash where the following keys are defined:
	delete has a value which is a Delete
	read has a value which is a Read
	write has a value which is a Write
Delete is a reference to a list where each element is an Uuid
Uuid is a string
Read is a reference to a list where each element is an Uuid
Write is a reference to a list where each element is an Uuid
Index is a reference to a hash where the following keys are defined:
	index_type has a value which is an Indextype
	filename has a value which is a Filename
	checksum_type has a value which is a Checksumtype
	version has a value which is a Version
	index has a value which is an IndexLocations
Version is a string
VersionParts is a reference to a hash where the following keys are defined:
	acl_ver has a value which is an AclVersion
	attributes_ver has a value which is an AttributesVersion
	file_ver has a value which is a FileVersion
AclVersion is a string
AttributesVersion is a string
FileVersion is a string
Error is a string
Httpcode is an int

</pre>

=end html

=begin text

$n is a Username
$p is a Password
$sp is a Searchparams
$nodes is a reference to a list where each element is a Node
Username is a string
Password is a string
Searchparams is a reference to a hash where the following keys are defined:
	skip has a value which is an int
	limit has a value which is an int
	query has a value which is a string
Node is a reference to a hash where the following keys are defined:
	D has a value which is a Nodedata
	E has a value which is an Error
	S has a value which is a Httpcode
Nodedata is a reference to a hash where the following keys are defined:
	id has a value which is an Identifier
	file has a value which is a File
	attributes has a value which is an Attributes
	acl has a value which is an Acl
	indexes has a value which is an Index
	version has a value which is a Version
	version_parts has a value which is a VersionParts
Identifier is a string
File is a reference to a hash where the following keys are defined:
	checksum has a value which is a Fingerprint
	name has a value which is a Filename
	size has a value which is a Filesize
Fingerprint is a reference to a hash where the following keys are defined:
	md5 has a value which is a string
	sha1 has a value which is a string
Filename is a string
Filesize is an int
Attributes is a string
Acl is a reference to a hash where the following keys are defined:
	delete has a value which is a Delete
	read has a value which is a Read
	write has a value which is a Write
Delete is a reference to a list where each element is an Uuid
Uuid is a string
Read is a reference to a list where each element is an Uuid
Write is a reference to a list where each element is an Uuid
Index is a reference to a hash where the following keys are defined:
	index_type has a value which is an Indextype
	filename has a value which is a Filename
	checksum_type has a value which is a Checksumtype
	version has a value which is a Version
	index has a value which is an IndexLocations
Version is a string
VersionParts is a reference to a hash where the following keys are defined:
	acl_ver has a value which is an AclVersion
	attributes_ver has a value which is an AttributesVersion
	file_ver has a value which is a FileVersion
AclVersion is a string
AttributesVersion is a string
FileVersion is a string
Error is a string
Httpcode is an int


=end text



=item Description

List nodes

=back

=cut

sub listNodes
{
    my $self = shift;
    my($n, $p, $sp) = @_;

    my @_bad_arguments;
    (!ref($n)) or push(@_bad_arguments, "Invalid type for argument \"n\" (value was \"$n\")");
    (!ref($p)) or push(@_bad_arguments, "Invalid type for argument \"p\" (value was \"$p\")");
    (ref($sp) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"sp\" (value was \"$sp\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to listNodes:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'listNodes');
    }

    my $ctx = $admServer::CallContext;
    my($nodes);
    #BEGIN listNodes

    my ($header, $request, $uri, $form_ref, $response);

    # create the uri
    $uri = $self->{shock_url} . "/node?";
    if (defined $sp->{'limit'}) {
      $uri .= 'limit=' . $sp->{limit} . '&';
    }
    if (defined $sp->{'skip'}) {
      $uri .= 'skip=' . $sp->{skip} . '&';
    }
    if (defined $sp->{'query'}) {
      $uri .= 'query=' . $sp->{query} . '&';
    }
    $uri =~ s/[\&\?]$//;
    
    # create the header
    $header = HTTP::Headers->new;
    $header->header('Content-Type' => 'text/plain');	
    $header->header('Host' => $uri);
    $header->authorization_basic($n, $p);

    # create the request
    $request = HTTP::Request->new( GET $uri, $header );
    
    # send the request
    $response = $self->{ua}->request($request);
    # print Dumper($response);
    
   # parse the results
    if ($response->is_success) {
      my $json = JSON->new()->allow_nonref();
      $u = $json->decode($response->decoded_content);
    }
    else {
      my ($package, $filename, $line) = caller;
      $u = "request failed at $package in $filename at $line " 
	. "with response status " . $response->status_line;		
    }
    
    # probably need some validation here.
    $nodes = $u;

    #END listNodes
    my @_bad_returns;
    (ref($nodes) eq 'ARRAY') or push(@_bad_returns, "Invalid type for return variable \"nodes\" (value was \"$nodes\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to listNodes:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'listNodes');
    }
    return($nodes);
}




=head2 viewNodes

  $obj->viewNodes($n, $p, $id, $v)

=over 4

=item Parameter and return types

=begin html

<pre>
$n is a Username
$p is a Password
$id is an Identifier
$v is a Viewparams
Username is a string
Password is a string
Identifier is a string
Viewparams is a reference to a hash where the following keys are defined:
	download has a value which is a Boolean
	index has a value which is a string
	chunksize has a value which is an int
	parts has a value which is a reference to a list where each element is an int
Boolean is an int

</pre>

=end html

=begin text

$n is a Username
$p is a Password
$id is an Identifier
$v is a Viewparams
Username is a string
Password is a string
Identifier is a string
Viewparams is a reference to a hash where the following keys are defined:
	download has a value which is a Boolean
	index has a value which is a string
	chunksize has a value which is an int
	parts has a value which is a reference to a list where each element is an int
Boolean is an int


=end text



=item Description

View nodes

=back

=cut

sub viewNodes
{
    my $self = shift;
    my($n, $p, $id, $v) = @_;

    my @_bad_arguments;
    (!ref($n)) or push(@_bad_arguments, "Invalid type for argument \"n\" (value was \"$n\")");
    (!ref($p)) or push(@_bad_arguments, "Invalid type for argument \"p\" (value was \"$p\")");
    (!ref($id)) or push(@_bad_arguments, "Invalid type for argument \"id\" (value was \"$id\")");
    (ref($v) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"v\" (value was \"$v\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to viewNodes:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'viewNodes');
    }

    my $ctx = $admServer::CallContext;
    #BEGIN viewNodes


    my ($header, $request, $uri, $form_ref, $response);

    # create the uri
    $uri = $self->{shock_url} . "/node/$id?";
    if (defined $v->{download} and $v->{download}) {
      $uri .= 'download' . '&';
    }
    if (defined $v->{parts}) {
      $uri .= 'parts=' . $v->{parts} . '&';
    }
    if (defined $v->{chunksize}) {
      $uri .= 'chunksize=' . $v->{chunksize} . '&';
    }
    $uri =~ s/[\&\?]$//;
    
    # create the header
    $header = HTTP::Headers->new;
    $header->header('Content-Type' => 'text/plain');	
    $header->header('Host' => $uri);
    $header->authorization_basic($n, $p);

    # create the request
    $request = HTTP::Request->new( GET $uri, $header );
    
    # send the request
    $response = $self->{ua}->request($request);
    # print Dumper($response);
    
   # parse the results
    if ($response->is_success) {
      my $json = JSON->new()->allow_nonref();
      $u = $json->decode($response->decoded_content);
    }
    else {
      my ($package, $filename, $line) = caller;
      $u = "request failed at $package in $filename at $line " 
	. "with response status " . $response->status_line;		
    }

    print $u, "\n";

    #END viewNodes
    return();
}




=head1 TYPES



=head2 Boolean

=over 4



=item Description

A Boolean data type


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 Uuid

=over 4



=item Description

A user id


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Filename

=over 4



=item Description

The name of a file including path information


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Error

=over 4



=item Description

Any error message returned


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Httpcode

=over 4



=item Description

The HTTP response code


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 Identifier

=over 4



=item Description

The node id


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Fingerprint

=over 4



=item Description

data structure for a fingerprint of a file


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
md5 has a value which is a string
sha1 has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
md5 has a value which is a string
sha1 has a value which is a string


=end text

=back



=head2 Filesize

=over 4



=item Description

The size of the file in bytes


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 File

=over 4



=item Description

Data structure for a file object in a node


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
checksum has a value which is a Fingerprint
name has a value which is a Filename
size has a value which is a Filesize

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
checksum has a value which is a Fingerprint
name has a value which is a Filename
size has a value which is a Filesize


=end text

=back



=head2 Attributes

=over 4



=item Description

Node attributes are an arbitrary json string that becomes queryable


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Delete

=over 4



=item Description

A list of users who can delete this node


=item Definition

=begin html

<pre>
a reference to a list where each element is an Uuid
</pre>

=end html

=begin text

a reference to a list where each element is an Uuid

=end text

=back



=head2 Read

=over 4



=item Description

A list of users who can read this node


=item Definition

=begin html

<pre>
a reference to a list where each element is an Uuid
</pre>

=end html

=begin text

a reference to a list where each element is an Uuid

=end text

=back



=head2 Write

=over 4



=item Description

A list of users who can write to this node


=item Definition

=begin html

<pre>
a reference to a list where each element is an Uuid
</pre>

=end html

=begin text

a reference to a list where each element is an Uuid

=end text

=back



=head2 Acl

=over 4



=item Description

access controls on this node


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
delete has a value which is a Delete
read has a value which is a Read
write has a value which is a Write

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
delete has a value which is a Delete
read has a value which is a Read
write has a value which is a Write


=end text

=back



=head2 Index

=over 4



=item Description

This is a json object for indexes, just a kludge for now


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Version

=over 4



=item Description

A version identifier for this node


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 AclVersion

=over 4



=item Description

Version identifiers for acls, attributes, and file


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 AttributesVersion

=over 4



=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 FileVersion

=over 4



=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 VersionParts

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
acl_ver has a value which is an AclVersion
attributes_ver has a value which is an AttributesVersion
file_ver has a value which is a FileVersion

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
acl_ver has a value which is an AclVersion
attributes_ver has a value which is an AttributesVersion
file_ver has a value which is a FileVersion


=end text

=back



=head2 Nodedata

=over 4



=item Description

access control information, and versioning information.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is an Identifier
file has a value which is a File
attributes has a value which is an Attributes
acl has a value which is an Acl
indexes has a value which is an Index
version has a value which is a Version
version_parts has a value which is a VersionParts

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is an Identifier
file has a value which is a File
attributes has a value which is an Attributes
acl has a value which is an Acl
indexes has a value which is an Index
version has a value which is a Version
version_parts has a value which is a VersionParts


=end text

=back



=head2 Node

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
D has a value which is a Nodedata
E has a value which is an Error
S has a value which is a Httpcode

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
D has a value which is a Nodedata
E has a value which is an Error
S has a value which is a Httpcode


=end text

=back



=head2 Username

=over 4



=item Description

A user name


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Password

=over 4



=item Description

A user password


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Userdata

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
uuid has a value which is an Uuid
name has a value which is a Username
passwd has a value which is a Password
admin has a value which is a Boolean

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
uuid has a value which is an Uuid
name has a value which is a Username
passwd has a value which is a Password
admin has a value which is a Boolean


=end text

=back



=head2 User

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
D has a value which is a Userdata
E has a value which is an Error
S has a value which is a Httpcode

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
D has a value which is a Userdata
E has a value which is an Error
S has a value which is a Httpcode


=end text

=back



=head2 Indextype

=over 4



=item Description

INDEX


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Filename

=over 4



=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Checksumtype

=over 4



=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 Version

=over 4



=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 IndexLocations

=over 4



=item Definition

=begin html

<pre>
a reference to a list where each element is a string
</pre>

=end html

=begin text

a reference to a list where each element is a string

=end text

=back



=head2 Index

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
index_type has a value which is an Indextype
filename has a value which is a Filename
checksum_type has a value which is a Checksumtype
version has a value which is a Version
index has a value which is an IndexLocations

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
index_type has a value which is an Indextype
filename has a value which is a Filename
checksum_type has a value which is a Checksumtype
version has a value which is a Version
index has a value which is an IndexLocations


=end text

=back



=head2 Nodeparams

=over 4



=item Description

data to be loaded resides.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
attr has a value which is a string
file has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
attr has a value which is a string
file has a value which is a string


=end text

=back



=head2 Searchparams

=over 4



=item Description

in the node's attributes and value is the value matched.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
skip has a value which is an int
limit has a value which is an int
query has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
skip has a value which is an int
limit has a value which is an int
query has a value which is a string


=end text

=back



=head2 Viewparams

=over 4



=item Description

View parameters.
- download default is false. when true the data file is downloaded and sent to
  stdout.
- index  available index values are 'size'. parts is required when index=size
- chunksize default is 1048578 bytes (1Mb), when index=size and parts=1,2 
- parts  this should be a comma seperated list of


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
download has a value which is a Boolean
index has a value which is a string
chunksize has a value which is an int
parts has a value which is a reference to a list where each element is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
download has a value which is a Boolean
index has a value which is a string
chunksize has a value which is an int
parts has a value which is a reference to a list where each element is an int


=end text

=back



=cut

1;
