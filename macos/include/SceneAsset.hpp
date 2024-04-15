#pragma once

#include "Log.hpp"

#include <filament/Engine.h>
#include <filament/RenderableManager.h>
#include <filament/Renderer.h>
#include <filament/Scene.h>
#include <filament/Texture.h>
#include <filament/TransformManager.h>

#include <math/vec3.h>
#include <math/vec4.h>
#include <math/mat3.h>
#include <math/norm.h>

#include <gltfio/Animator.h>
#include <gltfio/AssetLoader.h>
#include <gltfio/ResourceLoader.h>
#include <utils/NameComponentManager.h>

extern "C" {
    #include "FlutterFilamentApi.h"
}
template class std::vector<float>;
namespace polyvox {
    using namespace filament;
    using namespace filament::gltfio;
    using namespace utils;
    using namespace std;

    typedef std::chrono::time_point<std::chrono::high_resolution_clock> time_point_t;   

    enum AnimationType {
        MORPH, BONE, GLTF
    };

    struct AnimationStatus {
        time_point_t mStart = time_point_t::max();
        bool mLoop = false;
        bool mReverse = false;
        float mDuration = 0;  
        AnimationType type;
        int gltfIndex = -1;
    };

    // 
    // Use this to manually construct a buffer of frame data for morph animations.
    //
    struct MorphAnimationBuffer {
        utils::Entity mMeshTarget;
        int mNumFrames = -1;
        float mFrameLengthInMs = 0;
        vector<float> mFrameData;
        vector<int> mMorphIndices;
    };

    // 
    // Use this to construct a dynamic (i.e. non-glTF embedded) bone animation.
    // Only a single animation is supported at any time (i.e you can't blend animations).
    // Multiple bones are supported but these must be skinned to a single mesh target.
    //
    struct BoneAnimationBuffer {
        vector<utils::Entity> mMeshTargets;
        vector<uint8_t> mBones;
        vector<math::mat4f> mBaseTransforms;
        // vector<math::float3> mBaseTranslations; // these are the base transforms for the bones we will animate; the translations/rotations in mFrameData will be relative to this.
        // vector<math::quatf> mBaseRotations; // these are the base transforms for the bones we will animate; the translations/rotations in mFrameData will be relative to this.
        // vector<math::float3> mBaseScales; // these are the base transforms for the bones we will animate; the translations/rotations in mFrameData will be relative to this.
        size_t skinIndex = 0;
        int mNumFrames = -1;
        float mFrameLengthInMs = 0;
        vector<float> mFrameData;
    };

    struct SceneAsset {
        bool mAnimating = false;
        FilamentAsset* mAsset = nullptr;
        Animator* mAnimator = nullptr;

        // vector containing AnimationStatus structs for the morph, bone and/or glTF animations.
        vector<AnimationStatus> mAnimations;
        
        // the index of the last active glTF animation, 
        // used to cross-fade
        int fadeGltfAnimationIndex = -1;
        float fadeDuration = 0.0f;
        float fadeOutAnimationStart = 0.0f;

        MorphAnimationBuffer mMorphAnimationBuffer;
        BoneAnimationBuffer mBoneAnimationBuffer;

        // a slot to preload textures
        filament::Texture* mTexture = nullptr;

        // initialized to identity
        math::mat4f mPosition;
        
        // initialized to identity
        math::mat4f mRotation;
            
        float mScale = 1;

      SceneAsset(
            FilamentAsset* asset
        ) : mAsset(asset) {
            mAnimator = mAsset->getInstance()->getAnimator();
        }
    };
}
