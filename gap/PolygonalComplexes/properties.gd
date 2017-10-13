#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

## This chapter contains many diverse aspects of polygonal complexes.
## The current order may not be optimal, depending on what the future holds
#TODO current plan:
# 1) Invariants
# 2) connectivity
# 3) orientability
# 4) automorphism/isomorphism?
# 5) Properties of vertices
# 6) Properties of edges
# 7) Properties of faces (?);

#! @Chapter Properties of surfaces and complexes
#! @ChapterLabel Properties
#! 
#! TODO Introduction
#!
#! We will showcase these properties on several examples. One of them is the
#! <E>five-star</E>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_FiveTrianglesInCycle.tex};
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> fiveStar := SimplicialSurfaceByVerticesInFaces( 
#! >                [ [1,2,3], [1,3,5], [1,5,7], [1,7,11], [1,2,11] ] );;
#! @EndExampleSession
#TODO projective plane on four faces?

#! @Section Invariants
#! @SectionLabel Properties_Invariants
#!
#! This section collects invariants of polygonal complexes.
#!
#! TODO
#!

#! @Description
#! Return the <E>Euler-characteristic</E> of the given polygonal complex.
#! The Euler-characteristic is computed as
#! @BeginLogSession
#! gap> NrOfVertices(complex) - NrOfEdges(complex) + NrOfFaces(complex);
#! @EndLogSession
#! As an example, consider the five-star that was introduced at the
#! start of chapter <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex};
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> NrOfVertices(fiveStar);
#! 6
#! gap> NrOfEdges(fiveStar);
#! 10
#! gap> NrOfFaces(fiveStar);
#! 5
#! gap> EulerCharacteristic(fiveStar);
#! 1
#! @EndExampleSession
#! 
#! @Returns an integer
#! @Arguments complex
DeclareAttribute( "EulerCharacteristic", IsPolygonalComplex );


#! @Description
#! Check whether the given ramified polygonal surface is <E>closed</E>.
#! A ramified surface is closed if every edge is incident to <E>exactly</E> 
#! two
#! faces (whereas a polygonal complex is a ramified polygonal surface if 
#! every edge is incident to <E>at most</E> two faces).
#!
#! For example, the platonic solids are closed.
#! @ExampleSession
#! gap> IsClosed( Octahedron() );
#! true
#! gap> IsClosed( Dodecahedron() );
#! true
#! @EndExampleSession
#! In contrast, the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/> is not closed.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex};
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsClosed(fiveStar);
#! false
#! @EndExampleSession
#!
#! @Arguments ramSurf
DeclareProperty( "IsClosedSurface", IsRamifiedPolygonalSurface );
## We can't use IsClosed since this is blocked by the orb-package


#! @Section Degree-based properties and invariants
#! @SectionLabel Properties_Degrees

#TODO there is no good place for degrees, it seems.
# separating them into an own section feels weird, but putting them under 
# vertex properties feels weird as well (since there are methods like 
# InnerVertices etc. that feel too connected to separate them by the degrees..);

#TODO intro
#! This section contains properties and invariants that are based on the
#! degrees of the vertices. We have to distinguish two different definitions
#! for the degree of a vertex - we can either count the number of incident
#! edges of the number of incident faces.
#!
#! These two definitions are distinguished by calling them 
#! <K>EdgeDegreesOfVertices</K> and <K>FaceDegreesOfVertices</K>.
#! 
#TODO explain sorted/unsorted
#TODO mention vertexCounter, edgeCounter


#! @BeginGroup
#! @Description
#! The method <K>EdgeDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>) 
#! returns the <E>edge-degree</E> of the given vertex in the given
#! polygonal complex, i.e. the number of incident edges. The NC-version does
#! not check whether <A>vertex</A> is a vertex of <A>complex</A>.
#!
#! The attribute <K>EdgeDegreesOfVertices</K>(<A>complex</A>) collects all of
#! these degrees in a list that is indexed by the vertices, i.e.
#! <K>EdgeDegreesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>EdgeDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>). All other
#! positions of this list are not bound.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \input{Image_FiveTrianglesInCycle.tex};
#!    \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> EdgeDegreeOfVertex( fiveStar, 1 );
#! 5
#! gap> EdgeDegreeOfVertex( fiveStar, 5 );
#! 3
#! gap> EdgeDegreesOfVertices( fiveStar );
#! [ 5, 3, 3, , 3, , 3, , , , 3 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "EdgeDegreesOfVertices", IsPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "EdgeDegreeOfVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "EdgeDegreeOfVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup
#! @Description
#! The method <K>FaceDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>) 
#! returns the <E>face-degree</E> of the given vertex in the given
#! polygonal complex, i.e. the number of incident faces. The NC-version does
#! not check whether <A>vertex</A> is a vertex of <A>complex</A>.
#!
#! The attribute <K>FaceDegreesOfVertices</K>(<A>complex</A>) collects all of
#! these degrees in a list that is indexed by the vertices, i.e.
#! <K>FaceDegreesOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>FaceDegreeOfVertex</K>(<A>complex</A>, <A>vertex</A>). All other
#! positions of this list are not bound.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \input{Image_FiveTrianglesInCycle.tex};
#!    \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> FaceDegreeOfVertex( fiveStar, 1 );
#! 5
#! gap> FaceDegreeOfVertex( fiveStar, 5 );
#! 2
#! gap> EdgeDegreesOfVertices( fiveStar );
#! [ 5, 2, 2, , 2, , 2, , , , 2 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "FaceDegreesOfVertices", IsPolygonalComplex );
#! @Returns a positive integer
#! @Arguments complex, vertex
DeclareOperation( "FaceDegreeOfVertex", [IsPolygonalComplex, IsPosInt] );
#! @Arguments complex, vertex
DeclareOperation( "FaceDegreeOfVertexNC", [IsPolygonalComplex, IsPosInt] );
#! @EndGroup




#! @Description
#! Return the <E>vertex counter</E> of the given polygonal complex.
#! The vertex counter is a list that counts how many vertices are incident
#! to how many edges. If the entry at position <A>pos</A> is bound, it
#! contains the number of vertices that are incident to exactly <A>pos</A>
#! edges.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex};
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> List( EdgesOfVertices(complex), Size );
#! [ 5, 3, 3, , 3, , 3, , , , 3 ]
#! gap> VertexCounter(complex);
#! [ , , 5, , 1 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments complex
DeclareAttribute( "VertexCounter", IsPolygonalComplex );


#! @Description
#! Return the <E>edge counter</E> of the given polygonal complex.
#! The edge counter is a symmetric matrix <M>M</M> such that the entry
#! <M>M[i,j]</M> counts the number of edges such that the two vertices
#! of the edge are respectively incident to <M>i</M> and <M>j</M> edges.
#!
#! As an example, consider the five-star from the start of chapter
#! <Ref Chap="Chapter_Properties"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_FiveTrianglesInCycle.tex};
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> EdgeCounter(complex);
#! [ [ , , , , ], [ , , , , ], [ , , 5, , 5 ], [ , , , , ], [ , , 5, , ] ]
#! @EndExampleSession
#!
#! @Returns a matrix of positive integers
#! @Arguments complex
DeclareAttribute( "EdgeCounter", IsPolygonalComplex );


#TODO connectivity

#TODO orientability

#TODO automorphism/isomorphism
# automorphism group
# isomorphism test
# refer back to incidence graph

#TODO properties vertices

# TODO properties edges
