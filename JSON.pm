package Plack::Component::JSON;

use base qw(Plack::Component);
use strict;
use warnings;

#use Encode qw(encode);
use English;
use Error::Pure::Utils qw(err_get);
use Plack::Util::Accessor qw(cb_error content_type data data_type encoding json psgi_app status_code);
use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;

our $VERSION = 0.01;

sub call {
	my ($self, $env) = @_;

	$self->{'error'} = [];

	# Process actions.
	eval {
		$self->_process_actions($env);
	};
	if ($EVAL_ERROR) {
		$self->cb_error->($self, $EVAL_ERROR);
	}

	# PSGI application.
	if ($self->psgi_app) {
		my $app = $self->psgi_app;
		$self->psgi_app(undef);
		return $app;
	}

	# Process JSON.
	my $json_hr = {};
	if (@{$self->{'error'}}) {
		$json_hr->{'status'} = 'error';
		$json_hr->{'error'}->{'messages'} = [
			@{$self->{'error'}},
		],
	} else {
		$json_hr->{'status'} = 'success';
		$json_hr->{'data'} = $self->data;
	}

	# JSON Types.
	my $json_types_hr = {
		'status' => JSON_TYPE_STRING,
		exists $json_hr->{'error'} ? ('error' => {
			'messages' => json_type_arrayof(JSON_TYPE_STRING),
		}) : (),
		exists $json_hr->{'data'} ? (
			'data' => $self->data_type,
		) : (),
	};

	my $json = $self->json->encode($json_hr, $json_types_hr);

	# Return PSGI app.
	my $ret_ar = [
		$self->status_code,
		[
			'content-type' => $self->content_type,
		],
		[$json],
	];

	$self->_cleanup($env);

	return $ret_ar;
}

sub prepare_app {
	my $self = shift;

	$self->_prepare_app;

	return;
}

sub _cleanup {
	my ($self, $env) = @_;

	return;
}

# TODO Co s tim?
#sub _encode {
#	my ($self, $string) = @_;
#
#	return encode($self->encoding, $string);
#}

sub _prepare_app {
	my $self = shift;

	if (! $self->cb_error) {
		$self->cb_error(sub {
			my ($self, $eval_error) = @_;
			my @err_msg = err_get(1);
			foreach my $err_hr (@err_msg) {
				push @{$self->{'error'}}, $err_hr->{'msg'}->[0];
				# XXX Error parameters.
			}
		});
	}

	if (! $self->json) {
		$self->json(Cpanel::JSON::XS->new->canonical);
	}

	if (! $self->encoding) {
		$self->encoding('utf-8');
	}

	if (! $self->content_type) {
		$self->content_type('application/json; charset='.$self->encoding);
	}

	if (! $self->status_code) {
		$self->status_code(200);
	}

	return;
}

sub _process_actions {
	my ($self, $env) = @_;

	return;
}

1;

__END__
