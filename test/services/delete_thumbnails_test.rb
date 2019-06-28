require 'test_helper'

  class DeleteThumbnailsTest < ActiveSupport::TestCase
    it 'deletes thumbnails and knows if more thumbs may be deleted' do
      bucket = 'bucket-name-here'
      s3_resource = Minitest::Mock.new
      bucket_obj = Minitest::Mock.new
      bucket_obj_obj = Minitest::Mock.new
      thumbs = ["09e4e1d4f0b0376cac65d33160f6ff16e05c42cd.png", "3b00d24be0120b475726c8c2af2af2e43f82e9b1.png", "0e7e709654b4c34c96319011aee3106f85da87c3.png", "51142ab5769a4f1ba85e577929fb2fd94bd703e2.png", "6b8970bd6c0203d61bf262cd6a4e0390acc95727.png", "0e7bd7f9a3852d5bcc1f6b3c4b2832309b5d45c7.png", "3960d24800d40d5f23e438612385b5abf927e77b.png", "d8a8e64757873b99b5881a9b5d8b5bfaf07d9404.png", "fc1373acdaec9b54c7e70821c28e50d40da3183e.png", "6b4a066c8a6024ea771f190a2b8edc56acb0a085.png", "350fdf76d7c2e835851b4da40fc8770a0f9acd73.png", "1e0c2b13d7bd8735e71d3fe6964cda37efea7503.png", "e9d398f78a99efc5f010b06ee214c0c363a32353.png", "5523c5e0102a0620ceb6401006be0bf4bffb347f.png", "4cf9180bcda897a5f33a3b52fa6b45cb77aed6ea.png", "72b4e81a6472d71a36151b354d985a9ac1ea0a2f.png", "b9d38a8db5f0302e3d1a021c67c664372e50bbd6.png", "e50e1e4983ac9db677ae6279860f7d2198b1af52.png", "0f43ffefb1bc9a4006d760d54c7bed56f78f79c8.png", "d46ed43ee06e738346c9194ce3a31e194a07616b.png", "1937e0f5529f55d5adb4e24b605913fe134080ea.png", "c8c7bec4738787f60b5121ad602a6fb094819f55.png", "27a04edb58d7183dfaa3058d1cb04f5831f50ee1.png", "a7f34cc9d47ed64ad2710c8c7ede765e997ac73d.png", "4777712fe2cd69cb2ba61c9528687f40a3e710cf.png", "0ed0965362d8bcaf969a24a733f03e3b80991f63.png", "2fbb941ea1cd3176bb9567b95f0c87d38330e65c.png", "0d56ac2466f61c603cc640e78c512badb1d38be8.png", "ff4c8b41e5b2b787c56f21979baa53f9073acd05.png", "5265b5b7d7f77fb53fd39caaa732ae3de66f7028.png", "29214c7ef7cbb0a06165e6933ec9b0202ae7ed68.png", "fed8d2084deaf35cb2997497bfc485228c67db49.png", "29eb8569e46e2fe784c782505cc53a59673254fc.png", "3aa0d10909a7634a7b0e83f7c24ee9a63e812956.png", "2b1e5fce5b24121f0e59f0c864df7d87ecd365b9.png", "134e0221a31dcfe4c2ed6506644dcdb51aadc587.png", "7281f7ceb0de96ca87d5f3117c3e2c48f13589ba.png", "894276491f09b2f042ea0c9f4e5eebe92dd0d013.png", "0ec95e7e982f1a76c97e0c7f124418e9cd42b90f.png", "6a1f546d23da9e7d5716f6fc3f6396a4c22c803b.png", "9792412ab5decce288d4273b9500b528e3040cde.png", "64839f6e1d2fd9189736bb37e959343b425e2874.png", "9e98cb5961a6ef1f17d54f307597bf91ca1bc2d4.png", "b4a9ed803339c7fc57d12426d070f10c1d5c78f9.png", "4581563a9ad561c4d1fd7f862bf038578d48e933.png", "633bb881d473e8bbba00507b8a1dc94a4c64b083.png", "69a8b9a4fbe17594a23864b871dcbfb65295e3d8.png", "1dc4e3a47b2df526888c5416294e78ac3c9c3b76.png", "7ef407263fa50785dc79389ed32923e758af1e00.png", "1263eaa7f0bf3096e896ca2d405150b4aa556a75.png", "19ed0efce979b3215e15d9f26a55783f6a9843d8.png", "c6e20dcca44f8412ceafd331dbbe4a74624afdf0.png", "9307792fd88a67edfb8ae527247d32fd16a47e63.png", "a38adf373009dd64781ce715390cb3b4a6f73d38.png", "20b663d61ac0874168da8783d40416072116f890.png", "108ae03968757661c8d1ad1dfa473ddfc3d62490.png", "5dd52293fe5d4a61f08a189ebe0ac2c3a6a8fefc.png", "efaa45807b1deb836270a3f67d95f67a9552b461.png", "66b83c34c7f3ad83339273a544e2187298aa416d.png", "70226bd1ef4b796f0592f51d06df8ca994c26aec.png", "f9bccdd5fcded82edc6b39b3b24dfa6a448ba47b.png", "35938c3a0c75b91b5e71ad6d37793c8d24ca6448.png", "952b222fecf049c590feaefb76ea8533b8721c14.png", "3ba99433cc7247ebdd562a1d25fd992e0f681874.png", "5af24b63a93778c733b5af8dda5870701379d947.png", "addc3c1bf6c7feaf1bc55bd5292e234f22bcd4ad.png", "62c9aff464a97b02160b69c139fc566087751820.png", "ffd246ffb80feddf36c9972bd185a36ec002f7fb.png", "de40d2e89baf98c6f785883c1f80fdb941ac4c04.png", "3dd7f2a92993ec34bcd5302cfad91787ebce4318.png", "c51524f7e41ff8afd1c16420efd777e8d9154a68.png", "87c0a0fe6c4eb2cd36da390e25fdfd5d3dad64d0.png", "08638590365f2c6e4066d0d24e55b386c638d488.png", "e618ad928d644e06a6fa3cd268d78a8ac75c6775.png", "d41fedf0bf7e56dab101973f5016331d1ca125e6.png", "696da3ae19d18ab82dfcd8148a1ad8a8b2f81b88.png", "d0e2c8905a6d438a7126ff68d1925d8dbb6bdf56.png", "0c30f77d0e3179d0f48f2796e0d5876d7da7ddc9.png", "6af0554c12104ad35d6fd54e7d9788cb301066d3.png", "389d5626d0e0ecdbb245daaf44c5f3c014cb900b.png", "b204eb29dc5f4054161e4be1e3f700faa334e058.png", "a4aa7080d092fc07d07d49c6a8fc2a9b5280ce3f.png", "f056a4ff322dd2f4cf96b59713fbf247fd240224.png", "5fd97d0862ec9e45bed80da1583f241ef164983a.png", "63f233b11119937474239e458ffaa20d89a8e0c3.png", "acf089a7fa65cba1e03950d965936936d2b840bb.png", "999864094b9bd16dff4dd0f77a467cd1571b19a6.png", "5a756c86187cb22361bce824f69495ca603a6abf.png", "fb822adfa6183136220430362d5d0f2c8773a5fa.png", "02a123b376ce8ba5d8624bda96d89a29b89ae8fe.png", "de3dd2c944020895bc60680ed3dba6723cc1b61a.png"]
      thumbs.map do |thumb|
        bucket_obj.expect :object, bucket_obj_obj, [thumb]
        bucket_obj_obj.expect :delete, false, []
      end

      s3_resource.expect :bucket, bucket_obj, [bucket]
      deleter = DeleteThumbnails.new(param_string: 'q=125th',
                                     page: 1,
                                     bucket: bucket,
                                     s3_resource: s3_resource)
      deleter.delete!.must_equal thumbs
      deleter.last_batch?.must_equal false
      s3_resource.verify
    end

    describe 'when no results are returned' do
      it 'signals last batch' do
        bucket = 'bucket-name-here'
        s3_resource = Minitest::Mock.new
        bucket_obj = Minitest::Mock.new
        s3_resource.expect :bucket, bucket_obj, [bucket]
        deleter = DeleteThumbnails.new(param_string: 'q=sdfsdfsdf',
                                       page: 1,
                                       bucket: bucket,
                                       s3_resource: s3_resource)
        raise deleter.delete!.inspect
        # deleter.delete!.must_equal []
        deleter.last_batch?.must_equal true
        s3_resource.verify
      end
    end
  end
