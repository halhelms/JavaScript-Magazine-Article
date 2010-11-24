<html>
	<body>
		<div id="main"></div>
	</body>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
	<script type="text/javascript">
		$.get( 
			'controllers/CustomerController.cfc',
			{
				method : 'NewCustomer',
				displayContext : '##main',
				displayAction : 'replace',
				respondWith : 'event'
			},
			function( response ) {
				$( '#main' ).html( response.display );
			},
			'json'
		)
	</script>

</html>


