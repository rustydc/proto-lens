{-# LANGUAGE Rank2Types #-}

module Data.ProtoLens.Lens (
    Lens, Lens', lens, view, set, over, (^.), (.~), (&)
  ) where 

import Control.Applicative (Const(..))
import Data.Functor.Identity (Identity(..))

type Lens s t a b = forall f. Functor f => (a -> f b) -> s -> f t
type Lens' s a = forall f. Functor f => (a -> f a) -> s -> f s

lens :: Functor f => (s -> a) -> (s -> b -> t) -> (a -> f b) -> s -> f t
lens get set afb s = fmap (set s) $ afb (get s)
{-# INLINE lens #-}

view :: ((a -> Const a b) -> s -> Const a t) -> s -> a 
view = flip (^.)
{-# INLINE view #-}

set :: ((a -> Identity b) -> s -> Identity t) -> b -> s -> t
set l b s = runIdentity $ l (const (Identity b)) s
{-# INLINE set #-}

over :: ((a -> Identity b) -> s -> Identity t) -> (a -> b) -> s -> t
over l f s = runIdentity $ l (Identity . f) s
{-# INLINE over #-}

infixl 8 ^.
(^.) :: s -> ((a -> Const a b) -> s -> Const a t) -> a 
x ^. l = getConst $ l Const x
{-# INLINE (^.) #-}

infixr 4 .~
(.~) :: ((a -> Identity b) -> s -> Identity t) -> b -> s -> t
(.~) = set
{-# INLINE (.~) #-}

infixl 1 &
(&) :: a -> (a -> b) -> b
(&) = flip ($)
{-# INLINE (&) #-}
