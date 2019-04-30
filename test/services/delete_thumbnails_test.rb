require 'test_helper'

  class DeleteThumbnailsTest < ActiveSupport::TestCase
    it 'deletes thumbnails and knows if more thumbs may be deleted' do
      bucket = 'bucket-name-here'
      s3_resource = Minitest::Mock.new
      bucket_obj = Minitest::Mock.new
      bucket_obj_obj = Minitest::Mock.new
      thumbs = ["4a4ea35fb45bd9c5aad87aa8bd62830b5d456107.png", "d6aea1db32937e5891d1e6bbcd7bf58434aa22d0.png", "c7ea96600880bd3df903b552ca1bd1a2b087702e.png", "b065dcd4728675324d6a453bf6ce0b7528fdef69.png", "238bf5fd8aa32f3c25300f16bdbc8ea41cde527c.png", "2582f18948dbe8edd62cbb23af1d55713467f363.png", "e724743c015521dd2dd82b0c1502baf5d79efd47.png", "1aadb94020c22435bb7cc9d5c1f782008e62567d.png", "5944fada95588bdc815c3d7bf44566dc9663c1b4.png", "18c5bd4c6ec51f3acaa26e547edaa7169f3b17a2.png", "478fe9aa5b1700ccaa927665533ed9b7d4babbdf.png", "83b6b8892c0e13b8517579e1635609fbbe470c63.png", "d8be37efebfd5a7aa6028c5c3e846c9d1b1cb288.png", "d7d8c2071e1c771b18f065dccadc489a6c0ec4a0.png", "9f6e710d3f54afbbaa22fabd80ec4ed0b709109c.png", "e8779f8cd9d6c4447cde9de79f532ad28d37552a.png", "ff417f861a1220f4a93984007a6526a94dd08924.png", "8107a9e372f99a94d1e50eb55e057feda0220351.png", "2edeb4b75cb5df91baac2967d5878c525f00b4a7.png", "56ce878e09602faeb007b6f9e26161a488f38f44.png", "8fe3225770eecf917ef099594af05c345147eadc.png", "ad58d61bd7401e959e93015eacaf6c941b2127ba.png", "c3ae429d7f5d9ed9f09406821a4fb2c262277046.png", "d85d73709af591b2e9b77a9c1a5403d4a6ff3686.png", "bd7324f1b16545ce03fc1809332ff113338f1c0a.png", "0ac618739dc9f23b25b433545f92dde320fc26dc.png", "7f24ce29aa56ed192c9537b03dd50e967152830c.png", "e4187f319a751a034f2fa5801dda4ebb6c48c8e4.png", "9abb557fcab84b4d82467b1de23015bc7ce72102.png", "823ec16b328c0e4e94a7bbdf6353322ae5759871.png", "00749755fdd38e330b0e64a9b1ef6ded1928c649.png", "597493ea7d39ab7f7f99b2a06a6f4ca823e837bd.png", "f6ca5b5237059680671ff02dabde2f1479f6a5db.png", "65cd0d58af82556c13a62c0ef6d55aa8d75749d7.png", "314685e6f7199806f164b29bb7e24874acf4afb0.png", "ba3cef724dd75140a8686ed7f7732cd40984f079.png", "e1e23c7352a1938dbfaa45c8b6904d9451b9b6a4.png", "93431b874200f659f344b4141367a41721e89387.png", "be0c1f0cab5206de4a33804f9cf626692197c1f9.png", "a1b53fa6d722417a393ee41f0be988b4b0b1a09b.png", "80fc03be70ccf2c8356ca2201bdc6cc0c949d76a.png", "56bd8ba963223b2469351e359a4956e102e2d62d.png", "4b2fbf85111e21977a80670124ea0b1dfaaa5f9c.png", "9c6729bc8379ff89e5ddbc72b5c296d6bb85fe43.png", "2ca2f316f16400f0f7a39ba9a2fca5ec17be52d9.png", "24ee039034dbf923a520fd1b1574028b3b4c22f4.png", "9e49efbc49f39cc7c552f6788a3177188ba0a712.png", "9f943c1c015bc56dba2c1ff62e6927df50fd49e9.png", "669ca99777fe289bb4edf1f9958c0f96ade948a2.png", "4607ab871b7662cbda731f44d3c8bc7260e4b09a.png", "da4e4c841556354ffe990a514cabc915c43b788d.png", "ae92c0984d458b4fa3a0e1bb872f251fd67537ca.png", "7e2aef1e450bd3927650eb24aa642d0ffc1fbda1.png", "1d55547c0a12da82f4b0a9003cbc7d6c41e0416e.png", "38218f7db68f7cccdcd71b7572146ec7342aec5f.png", "19baef84448c275a4744747554eaded4f715d630.png", "dbdfea6aece795b8f23f67ab6551e478e2fb44fd.png", "86befcc932e1fa7d0edfc0f80ebe3620080dc898.png", "b9c347cee6a2df5938056a3b249d8c5b5cd33148.png", "0f53e9edfd44128014d52adc048a3a37433490b2.png", "df68be395cb8b22809d436a6f29a6bf2619c86bb.png", "72aea124cefb287a35f6906e8030488a3b61216f.png", "8df6e155b93433dccfcd2c7aa6fd826df684979f.png", "cd2bce2025fef8b50e53efb3ebdfaed920dd44d4.png", "1154b013407a28d61a82d1187994018362fea74b.png", "8c9179ffefa6806836525d50a955517d77709ea9.png", "a0fe8c7645da87d71ac35888e88f4e79a06014d8.png", "9669e2336c5270cc9fec1cd942c730d5a7f03b80.png", "611239f8667d6d92b2e4d39b69115cd84d2f9528.png", "c4fcc6427ea7cbf90659ec8ca9a6e23966be593a.png", "b5821fc7d1c0eb116502ff66af475113e405a99b.png", "4abdaec157b3fb8280744a712ccd46256cafe4a1.png", "c245e40d7fc0584d1f17513a2644265e7d28b673.png", "a1beaf95b23b35362337f42b8fa735f73f29da26.png", "17392140f42e3232eb794f8cb1e55fbb84090a9f.png", "d56b567eb569726f68b78ec89bca8de2c7215897.png", "31abba3b4801e1f95d304594a1769e20217237c4.png", "6f3580193bbdf41670d39776d81103664b507852.png", "85a1478849ebf4d5ca4b41f0fa7edc29deef9582.png", "25380fa52cd60c9ed617bacb5467c0feb124441f.png", "aa133b85c1beff987c5a2f511bc3944a3bad65c6.png", "9b34d9ebcadceb8c8d5784233fcf19e72ecde3b4.png", "02030a6d043e6085ce398634d28f653501f8b9d9.png", "2cc33587b25281e5d1d188b4a6462b39c9577179.png", "2dec2a07f577a039426c65dfe77eee5455554ba6.png", "cd1b4a72d3142053fc65556faca81d928582234e.png", "246bca6177a5dc2b81c3c33774ad97d2aa937534.png", "0a244f4a35db7c4b2262628077ef2d49f47333f9.png", "55cb3c9bd511f6c091f525e24c9fb28b3e5eef6a.png", "0fc1a8254d086b388faad2a92112bdb13df1d9ff.png", "844a75d1a108698c20663e48543fcc70e60f3f31.png", "71ed7401ab37f19200542f086dc9f6f79650d7af.png", "940186b9195492b70aa93753d174d526b4c3d2c6.png", "4490ada49bef17ced5e09360ab86b14578b7bc49.png", "fbca4636570f25eb200061696656731e7fb753dc.png", "87fe461c4321b26d7eeac22c512af4fb2293bfcb.png", "007f6740ae6eca118628086757a2e6f517fc14ff.png", "eb30fdc326ffdbc1123989f7af8c7519076517fb.png", "8d46939ec6358466460f65584a7755833e2d7cc3.png", "ec1bd979988e3a0c60234ce031457228095ad246.png", "7c2bac518ba0d3ab8e79d33901c36494b8f935c3.png", "41409b41a462b94c10e8477ef7e1256469822006.png", "2c0d0ee117ca1d64964cdebf279a9b8deba878a1.png", "5c4b6effc7e995b84e7f231c7af1e75b4f78ff96.png"]
      thumbs.map do |thumb|
        bucket_obj.expect :object, bucket_obj_obj, [thumb]
        bucket_obj_obj.expect :delete, false, []
      end

      s3_resource.expect :bucket, bucket_obj, [bucket]
      deleter = DeleteThumbnails.new(param_string: 'q=libraries',
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
        deleter.delete!.must_equal []
        deleter.last_batch?.must_equal true
        s3_resource.verify
      end
    end
  end
