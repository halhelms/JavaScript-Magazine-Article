<script type="text/javascript">
	$( 'document' ).bind( 
		'CustomerAdded,CustomerEdited,CustomerDeleted', 
		function( eventName, eventObject ) {
			$.get(
				'Customer.cfc?method=' + eventName,
				eventObject,
				function( response ) {
					if ( response.success ) {
						$( '#customers' ).replaceWith( response.display );
					} else {
						alert( 'A problem prevented the updating of the Customers display ');
					};
				},
				'json'	
			);
		};
	);
</script>