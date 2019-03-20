require 'test_helper'

module Umedia
  class FullTranscriptTest < ActiveSupport::TestCase
    describe 'when an item has one or more transcripts' do
      describe 'and is a compound' do
        let(:compound_item) { Umedia::ItemSearch.new(id: 'p16022coll95:33').item }
        it 'gathers page transcripts' do
          ft = FullTranscript.new(item: compound_item)
          ft.to_s.must_equal("October 29, 194&  To the members of the University Women's Club, Washington Branch, American Association of University Women:  You have received a referendum ballot on the question whether colored women qualified as national members shall be admitted to membership in the Washington Branch.  The undersigned, representing a number of members of the Branch, believes that you will be interested in having further information about the application which has brought up this question and about the provisions of the By-laws regarding membership.  It should be clearly understood that legally, no qualified applicant can be excluded from membership under the- By-laws as they stand. The present ballot, therefore, should be regarded as advisory only,  I -am informed that the matter will be discussed at the regular business meeting of the Branch on Monday, November4, at 7 p.m.  I am confident that, as American university women, you will base your decision on principles of justice and democracy.  Mrs. Clarence F. Swift, Sponsor of Mrs. Terrell October 24, 194& Facta about Mrs. Mary Church Terrell's Application for  Membership in the Washington Branch, A.A.U.W. (Prepared by Mrs. Clarence F. Swift)  Mrs. Mary Church Terrell, a graduate of Oberlin College with a distinguished record of public service (see page 3), is a member of the national American Association of University Women. She was a member of the Washington Branch in the early 1900's, but dropped out because of pressure of other activities. In recent years, however, she has on numerous occasions been the guest of members at the clubhouse.  On October 8, 1946, Mrs. Terrell applied, at the office, for reinstatement in the Branch, and paid a years dues. Her former membership was vouched for by one of the oldest and most respected members of the Branch and has since been confirmed by others, although records for that period have not yet been found. Mrs. Terrell's sponsor is Mrs.  Clarence F. Swift, 1020 19th Street, N.W.; Mrs* Swift is also an Oberlin graduate, a close friend of Mrs. Terrell since college days, a member of the national A.A.U.W. since 1884 and of the Washington Branch since 1939.  i  On October 9 the president of the Branch, Mrs. G. R. Wilhelm, called a meeting of the Executive Committee (the nine elected officers) to consider Mrs'. Terrell's application. The Committee is empowered to act between the meetings of the Board of Directors, which consists of the elected officers plus the chairmen of standing committees. Eight members of the Committee were present, and voted unanimously (the president not voting) to reject the application. They notified Mrs. Terrell and returned her money. Mrs. Wilhelm also informed Mrs. Swift. No reason was given for the action.  On October 11, Mrs. Swift, as Mrs. Terrell's sponsor, wrote to each member of the Board of Directors inquiring the basis for the rejection by the Executive Committee and appealing for consideration of the question by the Board.  On October 14 the Board held its regular monthly meeting. Of the twenty-one members, sixteen were present, and all but one (the president not voting) voted to uphold the action of the Executive Committee. Again no reason was given.  The By-laws contain no provision for any review of applications for membership. See page 2 for information regarding membership requirements and other pertinent matters.  A number of members have written to the president of the Branch wrote sting the rejection of the application, and asking that it be reconsidered by the Board. -2-  SUPPLMENTARY INFORMATION Washington Branch  From the By-laws of the Washington Branch, A.A.U.W.:  Article II, Objects:  The objects of the Washington Branch arc:  1. The development of an organization c-.f Washington women eligible to membership in the American Association of University Women which shall work  for the promotion of local educational and community interests.  2. Cooperation with the national Association in carrying out its  national and international program and in the operation of the national club-  house.  3. The objects of the American Association of University Women, i.e.: the uniting of the Alumnae of different institutions for practical educational work; the collection and. publication of statistical and other information concerning education; and, in general, the maintenance of high standards of education.  Article III, Membership:  1. Eligibility to Branch membership, whether national or associate, is determined according to the by-laws of the national Association.  2. Suspension or expulsion from Branch membership is within the powers of the Board of Directors.  3. Classes of Membership:  a. National members. Women who present satisfactory credentials for national membership, and pay the required initiation fee and dues, are admitted as national members of the Branch upon recommendation of one Branch member. Such national members have full privileges both within the Branch arid in the national Association.  (The rest of this Article concerns other classes of membership, and privileges of non-members.)  National A. A. [ I. W.  The only requirement for membership in the national American Association of University Women is an approved degree from an A.A.U.W.-approved institution.  The approved rating of the Association of American Universities is a requisite for approval by the A.A.U.W., which has in addition special standards pertaining to women and to the general education content of degrees.  None of the colored colleges or universities has yet been approved by the A.A.U.W.  The national Association has many colored members. Many branches have colored members.  The Clubhouse  The national clubhouse is owned by the national Association and operated jointly by it and the Washington Branch. MRS. MARY CHURCH TERRELL  A.B., Oberlin College, 188/+; A.M., Oberlin, 1888. Studied in Europe, 1888-1890. LL.D., Wilberforce University (Ohio), 1946.  One of the first two women of any race to be appointed to the Board of Education, District of Columbia; served eleven years.  This appointment made her the first colored woman in the world to serve on a board of education.  Active in the movement for woman suffrage.  Organized and was first president of the National Association of Colored Women. Was appointed honorary president for life.  Has represented colored women in three international conferences, at all of which she made addresses: International con-  gress of Women, Berlin, 1904 (made addresses in German and French); International Congress of Women for Permanent Peace, Zurich, 1919; World Fellowship of Faiths, London, 1937*  Was secretary of the Race Relations Committee, Washington Federation of Churches; Treasurer, Interracial Committee, under chairmanship of Dr. Charles Edward Russell.  Charter member of the National Association for the Advancement of Colored People.  Named as one of the \"\"one hundred most famous alumni\"\" of Oberlin College at its one hundredth anniversary, 1933*  Received a citation for social service at the Women's Centennial Congress, New York, November 1940.  Author, \"\"A Colored Woman in a White World\"\" (published 1940), with preface by H. G. Wells.  (See also \"\"Who's Who in America.\"\")")
        end
      end

      describe 'and item is not compound' do
        let(:item) { Umedia::ItemSearch.new(id: 'p16022coll289:3').item }
        it 'gathers page transcripts' do
          ft = FullTranscript.new(item: item)
          ft.to_s.must_equal("North America/United States/Minnesota")
        end
      end
    end

    describe 'when an item has  transcripts' do
      describe 'and is a compound' do
        let(:compound_item) { Umedia::ItemSearch.new(id: 'p16022coll272:6').item }
        it 'gathers page transcripts' do
          ft = FullTranscript.new(item: compound_item)
          ft.to_s.must_equal("")
        end
      end

      describe 'and item is not compound' do
        let(:item) { Umedia::ItemSearch.new(id: 'p16022coll135:0').item }
        it 'gathers page transcripts' do
          ft = FullTranscript.new(item: item)
          ft.to_s.must_equal("")
        end
      end
    end
  end
end