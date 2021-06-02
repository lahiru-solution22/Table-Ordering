'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "5611a1e681d9c9a7ddfc409c2d1615b2",
"index.html": "50e548f5d936d4cc37448961550d8706",
"/": "50e548f5d936d4cc37448961550d8706",
"main.dart.js": "ddb7cf89d2559636ba8ea0d76fc08710",
"favicon.png": "0629690c1952d0c4c213d07f2d62ffe6",
"icons/icon-193.png": "0629690c1952d0c4c213d07f2d62ffe6",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "5a7d0c7e06a5de24e1e5cba2767985cd",
"assets/images/email.png": "86411098e79aa5cf5baff0125c2d080d",
"assets/images/thumbs%2520down%2520false.png": "3b8395aa72d255a6bdaab6d36c310865",
"assets/images/user-plus.png": "fb859ebc0c1b0ed138cb8e2d03dac41e",
"assets/images/address.png": "d68cf80935bebb62df5c61ead82b244d",
"assets/images/thumbs%2520down%2520true.png": "c8f7c3ce6a185314606cd61fedf099d0",
"assets/images/fb.png": "51ae405e1b464603ee8ac65599eb5c95",
"assets/images/wel.png": "0629690c1952d0c4c213d07f2d62ffe6",
"assets/images/person.png": "eec4085f55155307dfd52458833e8ea1",
"assets/images/feedback.gif": "906273d785082dab744542d1b5f8b308",
"assets/images/thumbs%2520up%2520false.png": "524bf005752a396b3e45423333349940",
"assets/images/logo.png": "7c7837d02ede12fde60da5b5cec4b2ba",
"assets/images/calendar.png": "cc1ffb3af489e97e897eaf65c68044e0",
"assets/images/insta.png": "34ada1638ef7bef370e593e45e2cd29a",
"assets/images/cis.gif": "3bdf6baea8be67acb253178a12a87141",
"assets/images/phone.png": "a0bf7e86960a70852df5548b4f211ae1",
"assets/images/clock.png": "5f385467d4c0f53cd70b8f13a5cce92d",
"assets/images/temp.png": "349236968fc8f72c7d299e165e3521b0",
"assets/images/wel.gif": "6107f5cf867baaed2fce25f0827c39fc",
"assets/images/Union.png": "eec4085f55155307dfd52458833e8ea1",
"assets/images/feedback.png": "663e9af2e6d151929e0efacda16675e6",
"assets/images/weltop.jpg": "fb57b28355c6cad510b256455fbfa497",
"assets/images/checked.gif": "50b563e1bdcae81746f8c4ab59b911c7",
"assets/images/thumbs%2520up%2520true.png": "660adefb45f31c27d50c88184d6005b1",
"assets/AssetManifest.json": "ad93efa5807ef8e9d11b097931b89457",
"assets/NOTICES": "15148339fb4065a7bab436326d584ec8",
"assets/FontManifest.json": "840027133f63018dda8cc89e43fe59f5",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/assets/librarian-svgrepo-com.svg": "dda028d562d248971e5f1a8b824d75b9",
"assets/assets/worker-svgrepo-com.svg": "ca66e04763dff0af6160322613d921bf",
"assets/assets/fitness-svgrepo-com.svg": "5714f182c4f2a6baf6f6c6efdddc97e2",
"assets/assets/image_annotation.png": "0e1f4c577f4aaeeb523a0a84d4fa60ec",
"assets/assets/digital-7.ttf": "1e670d88b23c7ab956f1829e3828a210",
"assets/assets/ophthalmology-svgrepo-com.svg": "677d94de4392a05d3836984e7b6ca02c"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
