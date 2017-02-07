################################################################################
################################################################################
#####							Test a janus head
################################################################################
################################################################################



TestIsomorphicJanus := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [2,3,5], [3,6,9], [3,7],
		[ , , [2,3], , , [3,5], , , [2,5] ],
		[ , , [3,6,9], , , , [6,3,9] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a janus head.\n");
	fi;
end;

##
##	Test whether a simplicial surface is a janus head.
##
TestIsJanusHead := function( surface, messageSurfaceOrigin )

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin,
		3, 		# number of vertices
		3, 		# number of edges
		2,		# number of faces
		true,	# is it an actual surface?
		true,	# is it orientable?
		true, 	# is it connected?
		[2,2,2],		# the sorted degrees
		[,3],			# the vertex symbol
		1,		# the number of anomaly classes
		false	# does ear-removal reduce the surface?
	);
	
	TestIsomorphicJanus( surface, messageSurfaceOrigin );
	
end;


	


##########################################################################
## This method tests the functionality for the example of a janus head
## and the representation of a simplicial surface
TestJanusHead := function()
	local surf, name;

	name := "Janus head";

	surf := SimplicialSurfaceByDownwardIncidence( 3, 3, 2, [[1,2],[2,3],[3,1]], 
		[[1,2,3],[1,2,3]] );

	TestIsJanusHead( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;



##
##	Test whether a wild simplicial surface is a janus head.
##
TestIsWildJanusHead := function( surface, messageSurfaceOrigin )
	local vertexGroup, invGroup;

	# Check if it fulfills the criteria of a janus head (necessary to check
	# since some methods might have been overwritten).
	TestIsJanusHead( surface, messageSurfaceOrigin );
	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	#TODO how to check?

	vertexGroup := VertexGroup(surface);
	vertexGroup := vertexGroup[1] / vertexGroup[2];
	if Size( vertexGroup ) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " should have vertex group C_2.\n");
	fi;

	# Check group generated from the involutions
	invGroup := GroupOfWildSimplicialSurface( surface );
	if Size( invGroup ) <> 2 then
		Print( messageSurfaceOrigin );
		Print( " should have generated group C_2.\n");
	fi;

end;


##########################################################################
## This method tests the functionality for the example of a janus head
## and the representation as a wild simplicial surface
TestWildJanusHead := function()
	local surf, name, sig1, sig2, sig3, mrType, gens;

	name := "Janus head (wild)";

	sig1 := (1,2);
	sig2 := (1,2);
	sig3 := (1,2);
	mrType := AllEdgesOfSameType( 2, 1);

	gens := [sig1,sig2,sig3];


	# First try to extend a simplicial surface
	surf := SimplicialSurfaceByDownwardIncidence( 3, 3, 2, [[1,2],[2,3],[3,1]], 
		[[1,2,3],[1,2,3]] );
	surf := WildSimplicialSurfaceExtension( surf, gens );

	TestIsWildJanusHead( surf, Concatenation(name," by extension") );


	# Next we try to define it from scratch
	surf := WildSimplicialSurface( gens, mrType );

	TestIsWildJanusHead( surf, Concatenation(name," by mrType") );
	
end;


##
##	Test simplicial surface identifications
##
TestJanusHeadIdentification := function()
	local surf, id, colSurf;

	surf := SimplicialSurfaceByDownwardIncidence( 3, 3, 2, [[1,2],[2,3],[3,1]], 
		[[1,2,3],[1,2,3]] );
	colSurf := ColouredSimplicialSurface( surf );


	# Try a definition of neighbour identification
	id := NeighbourIdentification( surf, 1, 2 );
	if id <> NeighbourIdentification( colSurf, 1, 2) then
		Error("Can't define janus head neighbour identification independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id, "Neighbour identification of janus head" );
	TestColouredIdentificationConsistency( colSurf, id, "Neighbour identification of janus head and janus head" );
	if not IsConstantOnIntersection(colSurf, id) then
		Error("Neighbour identification of janus head should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id ) then
		Error("Neighbour identification of janus head should be applicable.");
	fi;
end;
