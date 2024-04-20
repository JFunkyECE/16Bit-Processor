
-- This file performs a 16x16 multiplication using a wallace tree
-- Author : Zachary Maidment

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Wallace_16x16_Multiplier is
  Port ( 
A : in  STD_LOGIC_VECTOR (15 downto 0);
B :    in  STD_LOGIC_VECTOR (15 downto 0);
prod : out  STD_LOGIC_VECTOR (31 downto 0)
  );
end Wallace_16x16_Multiplier;

architecture Behavioral of Wallace_16x16_Multiplier is

component FullAdder is
    port ( X : in  STD_LOGIC;
           Y : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           SUM : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
end component;

component HA is
    port ( x : in  STD_LOGIC;
           y : in  STD_LOGIC;
           S : out  STD_LOGIC;
           C : out  STD_LOGIC);
end component;

signal s: STD_LOGIC_VECTOR(11 to 91); --sum bits for second stage compression
signal c: STD_LOGIC_VECTOR(11 to 91); --carry bits for second stage compression
signal s2: STD_LOGIC_VECTOR(221 to 270); --sum bits for second stage compression
signal c2: STD_LOGIC_VECTOR(221 to 270); --carry bits for second stage compression
signal s3: STD_LOGIC_VECTOR(321 to 358); --sum bits for third stage compression
signal c3: STD_LOGIC_VECTOR(321 to 358); --carry bits for third stage compression
signal s4: STD_LOGIC_VECTOR(421 to 457); --sum bits for fourth stage compression
signal c4: STD_LOGIC_VECTOR(421 to 457); --carry bits for fourth stage compression
signal s5: STD_LOGIC_VECTOR(521 to 544); --sum bits for fifth stage compression
signal c5: STD_LOGIC_VECTOR(521 to 544); --carry bits for fifth stage compression
signal s6: STD_LOGIC_VECTOR(621 to 645); --sum bits for sixth stage compression
signal c6: STD_LOGIC_VECTOR(621 to 645); --carry bits for sixth stage compression
signal s7: STD_LOGIC_VECTOR(721 to 744); --sum bits for seventh stage compression
signal c7: STD_LOGIC_VECTOR(721 to 744); --carry bits for seventh stage compression
signal p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15 : std_logic_vector(15 downto 0);

begin

process(A,B)


-- Stage 1 - generate the partial products
begin
    for i in 0 to 15 loop
        p0(i) <= A(i) and B(0);
        p1(i) <= A(i) and B(1);
        p2(i) <= A(i) and B(2);
        p3(i) <= A(i) and B(3);
        p4(i) <= A(i) and B(4);
        p5(i) <= A(i) and B(5);
        p6(i) <= A(i) and B(6);
        p7(i) <= A(i) and B(7);
        p8(i) <= A(i) and B(8);
        p9(i) <= A(i) and B(9);
        p10(i) <= A(i) and B(10);
        p11(i) <= A(i) and B(11);
        p12(i) <= A(i) and B(12);
        p13(i) <= A(i) and B(13);
        p14(i) <= A(i) and B(14);
        p15(i) <= A(i) and B(15);
    end loop;       
end process;


-- Stage 3 - final bits in the product    
prod(0) <= p0(0);
prod(1) <= s(11);
prod(2) <= s2(221);
prod(3) <= s3(321);
prod(4) <= s4(421);
prod(5) <= s5(521);
prod(6) <= s6(621);
prod(7) <= s7(721);
prod(8) <= s7(722);
prod(9) <= s7(723);
prod(10) <= s7(724);
prod(11) <= s7(725);
prod(12) <= s7(726);
prod(13) <= s7(727);
prod(14) <= s7(728);
prod(15) <= s7(729);
prod(16) <= s7(730);
prod(17) <= s7(731);
prod(18) <= s7(732);
prod(19) <= s7(733);
prod(20) <= s7(734);
prod(21) <= s7(735);
prod(22) <= s7(736);
prod(23) <= s7(737);
prod(24) <= s7(738);
prod(25) <= s7(739);
prod(26) <= s7(740);
prod(27) <= s7(741);
prod(28) <= s7(742);
prod(29) <= s7(743);
prod(30) <= s7(744);
prod(31) <= c6(645);


-- note that all of the following port maps uses "positional port connections" rather than "explicit" connections which generally
-- makes code more readable - however in this case positional port connections is easier to follow!

-- Stage 2 - 1st iteration, 1st set of compressions
ha1 : HA port map(p0(1), p1(0), s(11), c(11));
fa1 : FullAdder port map(p0(2), p1(1), p2(0), s(12), c(12));
fa2 : FullAdder port map(p0(3), p1(2), p2(1), s(13), c(13));
fa3 : FullAdder port map(p0(4), p1(3), p2(2), s(14), c(14));
fa4 : FullAdder port map(p0(5), p1(4), p2(3), s(15), c(15));
fa5 : FullAdder port map(p0(6), p1(5), p2(4), s(16), c(16));
fa6 : FullAdder port map(p0(7), p1(6), p2(5), s(17), c(17));
fa7 : FullAdder port map(p0(8), p1(7), p2(6), s(18), c(18));
fa8 : FullAdder port map(p0(9), p1(8), p2(7), s(19), c(19));
fa9 : FullAdder port map(p0(10), p1(9), p2(8), s(20), c(20));
fa10 : FullAdder port map(p0(11), p1(10), p2(9), s(21), c(21));
fa11 : FullAdder port map(p0(12), p1(11), p2(10), s(22), c(22));
fa12 : FullAdder port map(p0(13), p1(12), p2(11), s(23), c(23));
fa13 : FullAdder port map(p0(14), p1(13), p2(12), s(24), c(24));
fa14 : FullAdder port map(p0(15), p1(14), p2(13), s(25), c(25));
ha2 : HA port map(p1(15), p2(14), s(26), c(26));

--Stage 2 1st iteration, 2nd set of compressions
ha3 : HA port map(p3(1), p4(0), s(27), c(27));
fa15 : FullAdder port map(p3(2), p4(1), p5(0), s(28), c(28));
fa16 : FullAdder port map(p3(3), p4(2), p5(1), s(29), c(29));
fa17 : FullAdder port map(p3(4), p4(3), p5(2), s(30), c(30));
fa18 : FullAdder port map(p3(5), p4(4), p5(3), s(31), c(31));
fa19 : FullAdder port map(p3(6), p4(5), p5(4), s(32), c(32));
fa20 : FullAdder port map(p3(7), p4(6), p5(5), s(33), c(33));
fa21 : FullAdder port map(p3(8), p4(7), p5(6), s(34), c(34));
fa22 : FullAdder port map(p3(9), p4(8), p5(7), s(35), c(35));
fa23 : FullAdder port map(p3(10), p4(9), p5(8), s(36), c(36));
fa24 : FullAdder port map(p3(11), p4(10), p5(9), s(37), c(37));
fa25 : FullAdder port map(p3(12), p4(11), p5(10), s(38), c(38));
fa26 : FullAdder port map(p3(13), p4(12), p5(11), s(39), c(39));
fa27 : FullAdder port map(p3(14), p4(13), p5(12), s(40), c(40));
fa28 : FullAdder port map(p3(15), p4(14), p5(13), s(41), c(41));
ha4 : HA port map(p4(15), p5(14), s(42), c(42));

--Stage 2 1st iteration, 3rd set of compressions
ha5 : HA port map(p6(1), p7(0), s(43), c(43));
fa29 : FullAdder port map(p6(2), p7(1), p8(0), s(44), c(44));
fa30 : FullAdder port map(p6(3), p7(2), p8(1), s(45), c(45));
fa31 : FullAdder port map(p6(4), p7(3), p8(2), s(46), c(46));
fa32 : FullAdder port map(p6(5), p7(4), p8(3), s(47), c(47));
fa33 : FullAdder port map(p6(6), p7(5), p8(4), s(48), c(48));
fa34 : FullAdder port map(p6(7), p7(6), p8(5), s(49), c(49));
fa35 : FullAdder port map(p6(8), p7(7), p8(6), s(50), c(50));
fa36 : FullAdder port map(p6(9), p7(8), p8(7), s(51), c(51));
fa37 : FullAdder port map(p6(10), p7(9), p8(8), s(52), c(52));
fa38 : FullAdder port map(p6(11), p7(10), p8(9), s(53), c(53));
fa39 : FullAdder port map(p6(12), p7(11), p8(10), s(54), c(54));
fa40 : FullAdder port map(p6(13), p7(12), p8(11), s(55), c(55));
fa41 : FullAdder port map(p6(14), p7(13), p8(12), s(56), c(56));
fa42 : FullAdder port map(p6(15), p7(14), p8(13), s(57), c(57));
ha6 : HA port map(p7(15), p8(14), s(58), c(58));

--Stage 2 1st iteration, 4th set of compressions
ha7 : HA port map(p9(1), p10(0), s(59), c(59));
fa43 : FullAdder port map(p9(2), p10(1), p11(0), s(60), c(60));
fa44 : FullAdder port map(p9(3), p10(2), p11(1), s(61), c(61));
fa45 : FullAdder port map(p9(4), p10(3), p11(2), s(62), c(62));
fa46 : FullAdder port map(p9(5), p10(4), p11(3), s(63), c(63));
fa47 : FullAdder port map(p9(6), p10(5), p11(4), s(64), c(64));
fa48 : FullAdder port map(p9(7), p10(6), p11(5), s(65), c(65));
fa49 : FullAdder port map(p9(8), p10(7), p11(6), s(66), c(66));
fa50 : FullAdder port map(p9(9), p10(8), p11(7), s(67), c(67));
fa51 : FullAdder port map(p9(10), p10(9), p11(8), s(68), c(68));
fa52 : FullAdder port map(p9(11), p10(10), p11(9), s(69), c(69));
fa53 : FullAdder port map(p9(12), p10(11), p11(10), s(70), c(70));
fa54 : FullAdder port map(p9(13), p10(12), p11(11), s(71), c(71));
fa55 : FullAdder port map(p9(14), p10(13), p11(12), s(72), c(72));
fa56 : FullAdder port map(p9(15), p10(14), p11(13), s(73), c(73));
ha8 : HA port map(p10(15),p11(14),s(74),c(74));

--Stage 2 1st iteration, 5th set of compressions
ha9 : HA port map(p12(1),p13(0),s(75),c(75));
fa57 : FullAdder port map(p12(2),p13(1),p14(0),s(76),c(76));
fa58 : FullAdder port map(p12(3),p13(2),p14(1),s(77),c(77));
fa59 : FullAdder port map(p12(4), p13(3), p14(2), s(78), c(78));
fa60 : FullAdder port map(p12(5), p13(4), p14(3), s(79), c(79));
fa61 : FullAdder port map(p12(6), p13(5), p14(4), s(80), c(80));
fa62 : FullAdder port map(p12(7), p13(6), p14(5), s(81), c(81));
fa63 : FullAdder port map(p12(8), p13(7), p14(6), s(82), c(82));
fa64 : FullAdder port map(p12(9), p13(8), p14(7), s(83), c(83));
fa65 : FullAdder port map(p12(10), p13(9), p14(8), s(84), c(84));
fa66 : FullAdder port map(p12(11), p13(10), p14(9), s(85), c(85));
fa67 : FullAdder port map(p12(12), p13(11), p14(10), s(86), c(86));
fa68 : FullAdder port map(p12(13), p13(12), p14(11), s(87), c(87));
fa69 : FullAdder port map(p12(14), p13(13), p14(12), s(88), c(88));
fa70 : FullAdder port map(p12(15), p13(14), p14(13), s(89), c(89));
ha10 : HA port map(p13(15),p14(14),s(90),c(90));

--Stage 2 2nd iteration, 1st set of compressions
ha11 : HA port map(s(12),c(11),s2(221),c2(221));
fa71 : FullAdder port map(s(13),c(12),p3(0),s2(222),c2(222));
fa72 : FullAdder port map(s(14),c(13),s(27),s2(223),c2(223));
fa73 : FullAdder port map(s(15),c(14),s(28),s2(224),c2(224));
fa74 : FullAdder port map(s(16),c(15),s(29),s2(225),c2(225));
fa75 : FullAdder port map(s(17),c(16),s(30),s2(226),c2(226));
fa76 : FullAdder port map(s(18),c(17),s(31),s2(227),c2(227));
fa77 : FullAdder port map(s(19),c(18),s(32),s2(228),c2(228));
fa78 : FullAdder port map(s(20),c(19),s(33),s2(229),c2(229));
fa79 : FullAdder port map(s(21),c(20),s(34),s2(230),c2(230));
fa80 : FullAdder port map(s(22),c(21),s(35),s2(231),c2(231));
fa81 : FullAdder port map(s(23),c(22),s(36),s2(232),c2(232));
fa82 : FullAdder port map(s(24),c(23),s(37),s2(233),c2(233));
fa83 : FullAdder port map(s(25),c(24),s(38),s2(234),c2(234));
fa84 : FullAdder port map(s(26),c(25),s(39),s2(235),c2(235));
fa85: FullAdder port map(p2(15),c(26),s(40),s2(236),c2(236));

--Stage 2 2nd iteration, 2nd set of compressions
ha12 : HA port map(c(28),p6(0),s2(237),c2(237));
ha13 : HA port map(c(29),s(43),s2(238),c2(238));
fa86 : FullAdder port map(c(30),s(44),c(43),s2(239),c2(239));
fa87 : FullAdder port map(c(31), s(45), c(44), s2(240), c2(240));
fa88 : FullAdder port map(c(32), s(46), c(45), s2(241), c2(241));
fa89 : FullAdder port map(c(33), s(47), c(46), s2(242), c2(242));
fa90 : FullAdder port map(c(34), s(48), c(47), s2(243), c2(243));
fa91 : FullAdder port map(c(35), s(49), c(48), s2(244), c2(244));
fa92 : FullAdder port map(c(36), s(50), c(49), s2(245), c2(245));
fa93 : FullAdder port map(c(37), s(51), c(50), s2(246), c2(246));
fa94 : FullAdder port map(c(38), s(52), c(51), s2(247), c2(247));
fa95 : FullAdder port map(c(39), s(53), c(52), s2(248), c2(248));
fa96 : FullAdder port map(c(40), s(54), c(53), s2(249), c2(249));
fa97 : FullAdder port map(c(41), s(55), c(54), s2(250), c2(250));
fa98 : FullAdder port map(c(42), s(56), c(55), s2(251), c2(251));
ha14 : HA port map(s(57),c(56),s2(252),c2(252));
ha15 : HA port map(s(58),c(57),s2(253),c2(253));
ha16 : HA port map(p8(15),c(58),s2(254),c2(254));

--Stage 2 2nd iteration, 3rd set of compressions
ha17 : HA port map(s(60),c(59),s2(255),c2(255));
fa99 : FullAdder port map(s(61),c(60),p12(0),s2(256),c2(256));
fa100 : FullAdder port map(s(62),c(61),s(75),s2(257),c2(257));
fa101 : FullAdder port map(s(63),c(62),s(76),s2(258),c2(258));
fa102 : FullAdder port map(s(64),c(63),s(77),s2(259),c2(259));
fa103 : FullAdder port map(s(65),c(64),s(78),s2(260),c2(260));
fa104 : FullAdder port map(s(66),c(65),s(79),s2(261),c2(261));
fa105 : FullAdder port map(s(67),c(66),s(80),s2(262),c2(262));
fa106 : FullAdder port map(s(68),c(67),s(81),s2(263),c2(263));
fa107 : FullAdder port map(s(69),c(68),s(82),s2(264),c2(264));
fa108 : FullAdder port map(s(70),c(69),s(83),s2(265),c2(265));
fa109 : FullAdder port map(s(71),c(70),s(84),s2(266),c2(266));
fa110 : FullAdder port map(s(72),c(71),s(85),s2(267),c2(267));
fa111 : FullAdder port map(s(73),c(72),s(86),s2(268),c2(268));
fa112 : FullAdder port map(s(74),c(73),s(87),s2(269),c2(269));
fa113 : FullAdder port map(p11(15),c(74),s(88),s2(270),c2(270));

--Stage 2 3rd iteration, 1st set of compressions
ha18 : HA port map(s2(222),c2(221),s3(321),c3(321));
ha19 : HA port map(s2(223),c2(222),s3(322),c3(322));
fa114 : FullAdder port map(s2(224),c2(223),c(27),s3(323),c3(323));
fa115 : FullAdder port map(s2(225),c2(224),s2(237),s3(324),c3(324));
fa116 : FullAdder port map(s2(226),c2(225),s2(238),s3(325),c3(325));
fa117 : FullAdder port map(s2(227),c2(226),s2(239),s3(326),c3(326));
fa118 : FullAdder port map(s2(228),c2(227),s2(240),s3(327),c3(327));
fa119 : FullAdder port map(s2(229),c2(228),s2(241),s3(328),c3(328));
fa120 : FullAdder port map(s2(230),c2(229),s2(242),s3(329),c3(329));
fa121 : FullAdder port map(s2(231),c2(230),s2(243),s3(330),c3(330));
fa122 : FullAdder port map(s2(232),c2(231),s2(244),s3(331),c3(331));
fa123 : FullAdder port map(s2(233),c2(232),s2(245),s3(332),c3(332));
fa124 : FullAdder port map(s2(234),c2(233),s2(246),s3(333),c3(333));
fa125 : FullAdder port map(s2(235),c2(234),s2(247),s3(334),c3(334));
fa126 : FullAdder port map(s2(236),c2(235),s2(248),s3(335),c3(335));
fa127 : FullAdder port map(s(41),c2(236),s2(249),s3(336),c3(336));
ha20 : HA port map(s(42),s2(250),s3(337),c3(337));
ha21 : HA port map(p5(15),s2(251),s3(338),c3(338));

--Stage 2 3rd iteration, 2nd set of compressions
ha22 : HA port map(c2(239),p9(0),s3(339),c3(339));
ha23 : HA port map(c2(240),s(59),s3(340),c3(340));
ha24 : HA port map(c2(241),s2(255),s3(341),c3(341));
fa128 : FullAdder port map(c2(242),s2(256),c2(255),s3(342),c3(342));
fa129 : FullAdder port map(c2(243),s2(257),c2(256),s3(343),c3(343));
fa130 : FullAdder port map(c2(244),s2(258),c2(257),s3(344),c3(344));
fa131 : FullAdder port map(c2(245),s2(259),c2(258),s3(345),c3(345));
fa132 : FullAdder port map(c2(246),s2(260),c2(259),s3(346),c3(346));
fa133 : FullAdder port map(c2(247),s2(261),c2(260),s3(347),c3(347));
fa134 : FullAdder port map(c2(248),s2(262),c2(261),s3(348),c3(348));
fa135 : FullAdder port map(c2(249),s2(263),c2(262),s3(349),c3(349));
fa136 : FullAdder port map(c2(250),s2(264),c2(263),s3(350),c3(350));
fa137 : FullAdder port map(c2(251),s2(265),c2(264),s3(351),c3(351));
fa138 : FullAdder port map(c2(252),s2(266),c2(265),s3(352),c3(352));
fa139 : FullAdder port map(c2(253),s2(267),c2(266),s3(353),c3(353));
fa140 : FullAdder port map(c2(254),s2(268),c2(267),s3(354),c3(354));
ha25 : HA port map(s2(269),c2(268),s3(355),c3(355));
ha26 : HA port map(s2(270),c2(269),s3(356),c3(356));
ha27 : HA port map(s(89),c2(270),s3(357),c3(357));

--Stage 2 4th iteration, 1st set of compressions
ha28 : HA port map(s3(322),c3(321),s4(421),c4(421));
ha29 : HA port map(s3(323),c3(322),s4(422),c4(422));
ha30 : HA port map(s3(324),c3(323),s4(423),c4(423));
fa141 : FullAdder port map(s3(325),c3(324),c2(237),s4(424),c4(424));
fa142 : FullAdder port map(s3(326),c3(325),c2(238),s4(425),c4(425));
fa143 : FullAdder port map(s3(327),c3(326),s3(339),s4(426),c4(426));
fa144 : FullAdder port map(s3(328),c3(327),s3(340),s4(427),c4(427));
fa145 : FullAdder port map(s3(329),c3(328),s3(341),s4(428),c4(428));
fa146 : FullAdder port map(s3(330),c3(329),s3(342),s4(429),c4(429));
fa147 : FullAdder port map(s3(331),c3(330),s3(343),s4(430),c4(430));
fa148 : FullAdder port map(s3(332),c3(331),s3(344),s4(431),c4(431));
fa149 : FullAdder port map(s3(333),c3(332),s3(345),s4(432),c4(432));
fa150 : FullAdder port map(s3(334),c3(333),s3(346),s4(433),c4(433));
fa151 : FullAdder port map(s3(335),c3(334),s3(347),s4(434),c4(434));
fa152 : FullAdder port map(s3(336),c3(335),s3(348),s4(435),c4(435));
fa153 : FullAdder port map(s3(337),c3(336),s3(349),s4(436),c4(436));
fa154 : FullAdder port map(s3(338),c3(337),s3(350),s4(437),c4(437));
fa155 : FullAdder port map(s2(252),c3(338),s3(351),s4(438),c4(438));
ha31 : HA port map(s2(253),s3(352),s4(439),c4(439));
ha32 : HA port map(s2(254),s3(353),s4(440),c4(440));

--Stage 2 4th iteration, 2nd set of compressions
ha33 : HA port map(c3(343),c(75),s4(441),c4(441));
fa156 : FullAdder port map(c3(344),c(76),p15(0),s4(442),c4(442));
fa157 : FullAdder port map(c3(345),c(77),p15(1),s4(443),c4(443));
fa158 : FullAdder port map(c3(346),c(78),p15(2),s4(444),c4(444));
fa159 : FullAdder port map(c3(347),c(79),p15(3),s4(445),c4(445));
fa160 : FullAdder port map(c3(348),c(80),p15(4),s4(446),c4(446));
fa161 : FullAdder port map(c3(349),c(81),p15(5),s4(447),c4(447));
fa162 : FullAdder port map(c3(350),c(82),p15(6),s4(448),c4(448));
fa163 : FullAdder port map(c3(351),c(83),p15(7),s4(449),c4(449));
fa164 : FullAdder port map(c3(352),c(84),p15(8),s4(450),c4(450));
fa165 : FullAdder port map(c3(353),c(85),p15(9),s4(451),c4(451));
fa166 : FullAdder port map(c3(354),c(86),p15(10),s4(452),c4(452));
fa167 : FullAdder port map(c3(355),c(87),p15(11),s4(453),c4(453));
fa168 : FullAdder port map(c3(356),c(88),p15(12),s4(454),c4(454));
fa169 : FullAdder port map(c3(357),c(89),p15(13),s4(455),c4(455));
fa170 : FullAdder port map(p14(15),c(90),p15(14),s4(456),c4(456)); 

--Stage 2 5th iteration, 1st set of compressions
ha34 : HA port map(s4(422),c4(421),s5(521),c5(521));
ha35 : HA port map(s4(423),c4(422),s5(522),c5(522));
ha36 : HA port map(s4(424),c4(423),s5(523),c5(523));
ha37 : HA port map(s4(425),c4(424),s5(524),c5(524));
ha38 : HA port map(s4(426),c4(425),s5(525),c5(525));
fa171 : FullAdder port map(s4(427),c4(426),c3(339),s5(526),c5(526)); --
fa172 : FullAdder port map(s4(428),c4(427),c3(340),s5(527),c5(527)); --
fa173 : FullAdder port map(s4(429),c4(428),c3(341),s5(528),c5(528)); --
fa174 : FullAdder port map(s4(430),c4(429),c3(342),s5(529),c5(529)); --
fa175 : FullAdder port map(s4(431),c4(430),s4(441),s5(530),c5(530));
fa176 : FullAdder port map(s4(432),c4(431),s4(442),s5(531),c5(531));
fa177 : FullAdder port map(s4(433),c4(432),s4(443),s5(532),c5(532));
fa178 : FullAdder port map(s4(434),c4(433),s4(444),s5(533),c5(533));
fa179 : FullAdder port map(s4(435),c4(434),s4(445),s5(534),c5(534));
fa180 : FullAdder port map(s4(436),c4(435),s4(446),s5(535),c5(535));
fa181 : FullAdder port map(s4(437),c4(436),s4(447),s5(536),c5(536));
fa182 : FullAdder port map(s4(438),c4(437),s4(448),s5(537),c5(537));
fa183 : FullAdder port map(s4(439),c4(438),s4(449),s5(538),c5(538));
fa184 : FullAdder port map(s4(440),c4(439),s4(450),s5(539),c5(539)); 
fa185 : FullAdder port map(s3(354),c4(440),s4(451),s5(540),c5(540));
ha39 : HA port map(s3(355),s4(452),s5(541),c5(541));
ha40 : HA port map(s3(356),s4(453),s5(542),c5(542));
ha41 : HA port map(s3(357),s4(454),s5(543),c5(543));
ha42 : HA port map(s(90),s4(455),s5(544),c5(544)); 

--Stage 2 6th iteration, 1st set of compressions
ha43 : HA port map(s5(522),c5(521),s6(621),c6(621));
ha44 : HA port map(s5(523),c5(522),s6(622),c6(622));
ha45 : HA port map(s5(524),c5(523),s6(623),c6(623));
ha46 : HA port map(s5(525),c5(524),s6(624),c6(624));
ha47 : HA port map(s5(526),c5(525),s6(625),c6(625));
ha48 : HA port map(s5(527),c5(526),s6(626),c6(626));
ha49 : HA port map(s5(528),c5(527),s6(627),c6(627));
ha50 : HA port map(s5(529),c5(528),s6(628),c6(628));
ha51 : HA port map(s5(530),c5(529),s6(629),c6(629));
fa186 : FullAdder port map(s5(531),c5(530),c4(441),s6(630),c6(630));
fa187 : FullAdder port map(s5(532),c5(531),c4(442),s6(631),c6(631));
fa188 : FullAdder port map(s5(533),c5(532),c4(443),s6(632),c6(632));
fa189 : FullAdder port map(s5(534),c5(533),c4(444),s6(633),c6(633));
fa190 : FullAdder port map(s5(535),c5(534),c4(445),s6(634),c6(634));
fa191 : FullAdder port map(s5(536),c5(535),c4(446),s6(635),c6(635));
fa192 : FullAdder port map(s5(537),c5(536),c4(447),s6(636),c6(636));
fa193 : FullAdder port map(s5(538),c5(537),c4(448),s6(637),c6(637));
fa194 : FullAdder port map(s5(539),c5(538),c4(449),s6(638),c6(638));
fa195 : FullAdder port map(s5(540),c5(539),c4(450),s6(639),c6(639));
fa196 : FullAdder port map(s5(541),c5(540),c4(451),s6(640),c6(640));
fa197 : FullAdder port map(s5(542),c5(541),c4(452),s6(641),c6(641));
fa198 : FullAdder port map(s5(543),c5(542),c4(453),s6(642),c6(642));
fa199 : FullAdder port map(s5(544),c5(543),c4(454),s6(643),c6(643));
fa200 : FullAdder port map(s4(456),c5(544),c4(455),s6(644),c6(644));
ha52 : HA port map(p15(15),c4(456),s6(645),c6(645)); 

--Stage 2 7th iteration, 1st set of compressions
ha53 : HA port map(s6(622),c6(621),s7(721),c7(721));
fa201 : FullAdder port map(s6(623),c6(622),c7(721),s7(722),c7(722));
fa202 : FullAdder port map(s6(624),c6(623),c7(722),s7(723),c7(723));
fa203 : FullAdder port map(s6(625), c6(624), c7(723), s7(724), c7(724));
fa204 : FullAdder port map(s6(626), c6(625), c7(724), s7(725), c7(725));
fa205 : FullAdder port map(s6(627), c6(626), c7(725), s7(726), c7(726));
fa206 : FullAdder port map(s6(628), c6(627), c7(726), s7(727), c7(727));
fa207 : FullAdder port map(s6(629), c6(628), c7(727), s7(728), c7(728));
fa208 : FullAdder port map(s6(630), c6(629), c7(728), s7(729), c7(729));
fa209 : FullAdder port map(s6(631), c6(630), c7(729), s7(730), c7(730));
fa210 : FullAdder port map(s6(632), c6(631), c7(730), s7(731), c7(731));
fa211 : FullAdder port map(s6(633), c6(632), c7(731), s7(732), c7(732));
fa212 : FullAdder port map(s6(634), c6(633), c7(732), s7(733), c7(733));
fa213 : FullAdder port map(s6(635), c6(634), c7(733), s7(734), c7(734));
fa214 : FullAdder port map(s6(636), c6(635), c7(734), s7(735), c7(735));
fa215 : FullAdder port map(s6(637), c6(636), c7(735), s7(736), c7(736));
fa216 : FullAdder port map(s6(638), c6(637), c7(736), s7(737), c7(737));
fa217 : FullAdder port map(s6(639), c6(638), c7(737), s7(738), c7(738));
fa218 : FullAdder port map(s6(640), c6(639), c7(738), s7(739), c7(739));
fa219 : FullAdder port map(s6(641), c6(640), c7(739), s7(740), c7(740));
fa220 : FullAdder port map(s6(642), c6(641), c7(740), s7(741), c7(741));
fa221 : FullAdder port map(s6(643), c6(642), c7(741), s7(742), c7(742));
fa222 : FullAdder port map(s6(644), c6(643), c7(742), s7(743), c7(743));
fa223 : FullAdder port map(s6(645), c6(644), c7(743), s7(744), c7(744));


end Behavioral;
