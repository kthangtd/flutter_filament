#include "PolyvoxFilamentApi.h"
#include "FilamentViewer.hpp"
#include "ResourceBuffer.hpp"
#include "SceneResources.hpp"
#include <functional>

using namespace polyvox;
using namespace std;

extern "C" {
    using RawLoadType = ResourceBuffer(const char*, void* resource);
    using RawFreeType = void(uint32_t, void*);

    void* filament_viewer_new_ios(void* pb, void* loadResource, void* freeResource, void* resources) {
            
      FreeResource _freeResource = [=](uint32_t rid) {
        reinterpret_cast<RawFreeType*>(freeResource)(rid, resources);
      };
    
      function<ResourceBuffer(const char*)> _loadResource = [=](const char* uri){
        auto cast = reinterpret_cast<RawLoadType*>(loadResource);
        return cast(uri, resources);
      };
            
      auto viewer = new FilamentViewer(pb,_loadResource, _freeResource);

      return (void*)viewer;
    }
    void create_swap_chain(void* viewer, void* texture) {
        ((FilamentViewer*)viewer)->createSwapChain(texture);
    }
}