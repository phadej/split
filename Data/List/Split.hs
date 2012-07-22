-----------------------------------------------------------------------------
-- |
-- Module      :  Data.List.Split
-- Copyright   :  (c) Brent Yorgey, Louis Wasserman 2008-2012
-- License     :  BSD-style (see LICENSE)
-- Maintainer  :  Brent Yorgey <byorgey@gmail.com>
-- Stability   :  stable
-- Portability :  Haskell 2010
--
-- The "Data.List.Split" module contains a wide range of strategies
-- for splitting lists with respect to some sort of delimiter, mostly
-- implemented through a unified combinator interface.  The goal is to
-- be flexible yet simple.  Scroll past the Synopsis for usage,
-- examples, and detailed documentation of all exported functions.  If
-- you want to learn about the implementation, see
-- "Data.List.Split.Internals".
--
-- A darcs repository containing the source (including a module with
-- over 40 QuickCheck properties) can be found at
-- <http://code.haskell.org/~byorgey/code/split>.
--
-----------------------------------------------------------------------------
module Data.List.Split (

                       -- * Getting started
                       -- $started

                       -- * Convenience functions
                       -- $conv

                         splitOn
                       , splitOneOf
                       , splitWhen
                       , sepBy
                       , sepByOneOf
                       , endBy
                       , endByOneOf

                       , unintercalate

                       , wordsBy
                       , linesBy

                       -- * Other splitting methods
                       -- $other
                       , splitEvery
                       , chunk
                       , splitPlaces
                       , splitPlacesBlanks
                       , chop

                       -- * Splitting combinators
                       -- $comb

                       , Splitter
                       , defaultSplitter
                       , split

                       -- ** Basic strategies
                       -- $basic

                       , oneOf
                       , onSublist
                       , whenElt

                       -- ** Strategy transformers
                       -- $transform

                       , dropDelims
                       , keepDelimsL
                       , keepDelimsR
                       , condense
                       , dropInitBlank
                       , dropFinalBlank

                       -- ** Derived combinators
                       -- $derived

                       , dropBlanks
                       , startsWith
                       , startsWithOneOf
                       , endsWith
                       , endsWithOneOf

                       ) where

import Data.List.Split.Internals

-- $started
-- To get started, you should take a look at the functions 'splitOn',
-- 'splitWhen', 'sepBy', 'endBy', 'splitEvery', 'splitPlaces', and
-- other functions listed in the next two sections.  These functions
-- implement various common splitting operations, and one of them will
-- probably do the job 90\% of the time.  For example:
--
-- > > splitOn "x" "axbxc"
-- > ["a","b","c"]
-- > > splitOn "x" "axbxcx"
-- > ["a","b","c",""]
-- > > endBy ";" "foo;bar;baz;"
-- > ["foo","bar","baz"]
-- > > splitWhen (<0) [1,3,-4,5,7,-9,0,2]
-- > [[1,3],[5,7],[0,2]]
-- > > splitOneOf ";.," "foo,bar;baz.glurk"
-- > ["foo","bar","baz","glurk"]
-- > > splitEvery 3 ['a'..'z']
-- > ["abc","def","ghi","jkl","mno","pqr","stu","vwx","yz"]
--
-- If you want more flexibility, however, you can use the combinator
-- library in terms of which these functions are defined.  For more
-- information, skip to the section labeled \"Splitting Combinators\".
--
-- Note that the goal of this library is to be flexible yet simple.
-- It does not implement any particularly sophisticated list-splitting
-- methods, nor is it tuned for speed.  If you find yourself wanting
-- something more complicated or optimized, it probably means you
-- should use a real parsing or regular expression library.

-- $conv
-- These functions implement some common splitting strategies.  Note
-- that all of the functions in this section drop delimiters from the
-- final output, since that is a more common use case even though it
-- is not the default.

-- $other
-- Other useful splitting methods which are not implemented using the
-- combinator framework.

-- $comb
-- The core of the library is the 'Splitter' type, which represents a
-- particular list-splitting strategy.  All of the combinators revolve
-- around constructing or transforming 'Splitter' objects; once a
-- suitable 'Splitter' has been created, it can be run with the
-- 'split' function.  For example:
--
-- > > split (dropBlanks . condense $ whenElt (<0)) [1,2,4,-5,-6,4,9,-19,-30]
-- > [[1,2,4],[-5,-6],[4,9],[-19,-30]]

-- $basic
-- All these basic strategies have the same parameters as the
-- 'defaultSplitter' except for the delimiter.

-- $transform
-- Functions for altering splitting strategy parameters.

-- $derived
-- Combinators which can be defined in terms of other combinators, but
-- are provided for convenience.
