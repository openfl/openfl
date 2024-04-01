package openfl.security;

#if !flash
/**
	The `CertificateStatus` class defines constants used to report the results of
	certificate validation processing by a `SecureSocket` object.

	@see `openfl.net.SecureSocket`
	@see `openfl.net.SecureSocket.serverCertificateStatus`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract CertificateStatus(String) from String to String

{
	/**
		The certificate is outside its valid period.

		Indicates that certificate validation processing was attempted, but
		failed because the validity period of the certificate is either before
		or after the current date. On some operating systems, the `notYetValid`
		status is reported when the current date is before the validity period
		of the cerificate. On other operating systems, the `expired` status is
		reported in both cases.
	**/
	public var EXPIRED = "expired";

	/**
		An invalid certificate.

		Indicates that certificate validation processing was attempted, but
		failed. This is the generic faliure status that is reported when a more
		specific certificate status cannot be determined.
	**/
	public var INVALID = "invalid";

	/**
		A root or intermediate certificate in this certificate's chain is
		invalid.

		Indicates that certificate validation processing was attempted, but
		failed because the certificate's trust chain was invalid.
	**/
	public var INVALID_CHAIN = "invalidChain";

	/**
		The certificate is not yet valid.

		Indicates that a certificate is not yet valid. The current date is
		before the notBefore date/time of the certificate.
	**/
	public var NOT_YET_VALID = "notYetValid";

	/**
		The certificate common name does not match the expected host name.

		Indicates that certificate validation processing was attempted, but
		failed because the certificate's common name does not match the fully
		qualified domain name of the host.
	**/
	public var PRINCIPAL_MISMATCH = "principalMismatch";

	/**
		The certificate has been revoked.

		Indicates that certificate validation processing was attempted, but
		failed because the certificate has been revoked. On some operating
		systems, the `revoked` status is also reported when the certificate (or
		its root certificate) has been added to the list of untrusted
		certificates on the client computer.
	**/
	public var REVOKED = "revoked";

	/**
		A valid, trusted certificate.

		Indicates that a certificate has not expired, has not failed a
		revocation check, and chains to a trusted root certificate.
	**/
	public var TRUSTED = "trusted";

	/**
		The validity of the certificate is not known.

		Indicates that certificate validation processing has not been performed
		yet on a certificate.
	**/
	public var UNKNOWN = "unknown";

	/**
		The certificate does not chain to a trusted root certificate.

		Indicates that certificate validation processing was attempted, but that
		the certificate does not chain to any of the root certificates in the
		client trust store. On some operating systems, the `untrustedSigners`
		status is also reported if the certificate is in the list of untrusted
		certificates on the client computer.
	**/
	public var UNTRUSTED_SIGNERS = "untrustedSigners";
}
#else
typedef CertificateStatus = flash.security.CertificateStatus;
#end
