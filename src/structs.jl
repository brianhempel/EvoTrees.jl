# define an abstrat tree node type - concrete types are TreeSplit and TreeLeaf
abstract type Node{T<:AbstractFloat} end

# store perf info of each variable
mutable struct SplitInfo{L, T<:AbstractFloat, S<:Int}
    gain::T
    ∑δL::SVector{L,T}
    ∑δ²L::SVector{L,T}
    ∑𝑤L::SVector{1,T}
    ∑δR::SVector{L,T}
    ∑δ²R::SVector{L,T}
    ∑𝑤R::SVector{1,T}
    gainL::T
    gainR::T
    𝑖::S
    feat::S
    cond::T
end

struct TreeNode{L, T<:AbstractFloat, S<:Integer, B<:Bool}
    left::S
    right::S
    feat::S
    cond::T
    gain::T
    pred::SVector{L,T}
    split::B
end

TreeNode(left::S, right::S, feat::S, cond::T, gain::T, L::S) where {T<:AbstractFloat, S<:Integer} = TreeNode{L,T,S,Bool}(left, right, feat, cond, gain, zeros(SVector{L,T}), true)
TreeNode(pred::SVector{L,T}) where {L,T} = TreeNode(0, 0, 0, zero(T), zero(T), pred, false)

# single tree is made of a root node that containes nested nodes and leafs
struct TrainNode{L, T<:AbstractFloat, S<:Integer}
    parent::S
    depth::S
    ∑δ::SVector{L,T}
    ∑δ²::SVector{L,T}
    ∑𝑤::SVector{1,T}
    gain::T
    𝑖::Vector{S}
    𝑗::Vector{S}
end

# single tree is made of a root node that containes nested nodes and leafs
struct Tree{L, T<:AbstractFloat, S<:Integer}
    nodes::Vector{TreeNode{L,T,S,Bool}}
end

# eval metric tracking
mutable struct Metric
    iter::Int
    metric::Float32
end
Metric() = Metric(0, Inf)

# gradient-boosted tree is formed by a vector of trees
struct GBTree{L, T<:AbstractFloat, S<:Integer}
    trees::Vector{Tree{L,T,S}}
    params::EvoTypes
    metric::Metric
    K::Int
    levels
end
