-- CM01 [Rough Cut] Capacity Planning
-- process CM01 for display on a site-wide Gantt chart

-- just the start dates and finish dates

-- Authored by David Harris 2025-07-15

-- ====Drop======================================================================

-- drop table if exists materialcontext;
drop table if exists CM01import;
drop table if exists WorkCenter;
drop table if exists textimport;
drop table if exists GroupByOrder;


-- ===Import=======================================================================


-- attach database '../LogSpec_builder/BOMreport_logspec_20250630.db' as BOMpaths;




CREATE TABLE if not exists CM01import (_1,_2,_3,_4,_5,_6,_7,_8,_9,_10,_11,_12,
	_13,_14,_15,_16,_17,_18,_19)
;

.import "s:/CC Concurrence Workspace/HARRISDM/RM06analyst/SAPdata/Charfixdata/SAPspool_20250718/charfix-FP10000232566.TXT" CM01import

-- ===Prepare CM01==========================================================



-- create table if not exists materialcontext as select * from BOMpaths.MaterialContext; 





CREATE TABLE WorkCenter (
       business,
       technology,
       workcenter,
       description
);

INSERT INTO WorkCenter
	VALUES

		('beauty','LipCare','20A','L20 Labeler-FilledSticks'),
		('beauty','LipCare','26A','L26 HighspeedFilledSticks'),
		('beauty','LipCare', '26B','Line 26 - Bulk'),
		('beauty','LipCare','27A','L27 FilledSticks'),
		('beauty','LipCare', '27B','Line 27B'),
		('beauty','LipCare', '36A','L36 L37 AlloydLipcare'),
		('beauty','LipCare', '40A','L40 Single-LipcareFFS'),
		('beauty','LipCare', '41A','L41 Multi-LipcareFFS'),
		('beauty','LipCare', '45A','L45 LipcareRefill'),

		('beauty','LipCare', 'CM1','C/S Colormix'),
		('beauty','LipCare', 'CSPHARM','C/S Pharmacy'),
		('beauty','LipCare', 'CHAPMF1','C/S MFG'),


		('beauty','Cosmetics', '64A','L64 Anbesol-WIP'),
		('beauty','Cosmetics', '65A','L65 Deo-FG'),
		('beauty','Cosmetics', '91A','L91 Deo-WIP'),
		('beauty','Cosmetics', '92A','L92 misc-FG'),
		('beauty','Cosmetics', '97A','L97 Deo-FG'),

		('beauty','Cosmetics', 'OLSA-5T','OLSA 5T Mix Room 2'),
		('beauty','Cosmetics', 'OLSA-1T','OLSA 1T Mix Room 2'),

		('beauty','Cosmetics', '260','Mfg Tank 260 Gallon'),



		('beauty','aerosol', 'AER201','Aerosol Line 201 Rotary'),
		('beauty','aerosol', 'AER202','Aerosol Line 202 Index'),
		('beauty','aerosol', 'AER203','Aerosol Line 203 Bag on Valve'),
		('beauty','aerosol', 'AER204','Aerosol Line 204 Rotary'),
		('beauty','aerosol', 'AER205','Aerosol Line 205 Index'),

		('beauty','aerosol', 'AERMT1','Aerosol Mix Tank 1'),


		('pharma','Solids', '33A','Line 33'),
		('pharma','Solids','72A','L72 Blister'),
		('pharma','Solids','78A','L78 Pouch'),
		('pharma','Solids','79A','L79 Pouch'),
		('pharma','Solids','82A','L82 Bottles'),
		('pharma','Solids','83A','L83 Bottles'),

		('pharma','Solids', 'SB1','SUPP BULK'),
		('pharma','Solids', 'PB1','Cooling Gel MFG'),


		('pharma','Liquids','5A','L5 4ozBottles'),
		('pharma','Liquids','61A','L61 GlassBottles'),
		('pharma','Liquids','62A','L62 8ozBottles'),
		('pharma','Liquids','63A','L63 4ozBottles'),

		('pharma','Liquids', 'AD1','Advil Mfg'),
		('pharma','Liquids', 'SY1','Syrup MFG'),


		('pharma','Topicals', '31A','L31 Monistat-FG'),
		('pharma','Topicals', '32A','L32 Anbesol-FG'),
		('pharma','Topicals', '34A','L34 Monistat-FG'),
		('pharma','Topicals', '35A','L35 Anbesol-Monistat-WIP'),
		('pharma','Topicals', '50A','L50 Monistat-WIP'),
		('pharma','Topicals', '51A','L51 PrepH-FG'),
		('pharma','Topicals', '57A','L57 PrepH-Monistat-WIP'),
		('pharma','Topicals', '58A','L58 Monistat-WIP'),
		('pharma','Topicals', '59A','L59 PrepH-Monistat-WIP'),
		('pharma','Topicals', '66A','L66 PrepH-FG'),
		('pharma','Topicals', '77A','L77 Monistat-WIP'),


		('other','other', 'PHARMACY','Main Pharmacy'),
		('other','other', 'CB1','Fryma MFG'),
		('other','other', 'DISPLAYA','DISPLAY PACKING')


;





CREATE  TABLE textimport AS 
	SELECT
		rowid,
		TRIM(_3) AS WorkCenter,
		TRIM(_4) AS Material,
		TRIM(_6) AS PeggedRqmt,
		trim(_18) as RqmtTypeRank,		
		REPLACE(substr(TRIM(_7),-4,-100),',','')*1.0 AS RqmtQty,
		TRIM(substr(_7,-4)) AS RqmtUnit,
		TRIM(_8) AS SchedLatestStart,
		TRIM(_9) AS SchedLatestFinish,
		TRIM(substr(_10,-4,-100))*1.0 AS SAPDuration,	
		TRIM(substr(_10,-4)) AS DurUnit
	FROM CM01import WHERE _2 LIKE '20__-%'
;


	
CREATE TABLE GroupByOrder AS
	SELECT
		c.rowid as WCrank,
		c.business,
		c.technology,
		c.description as WCdescription,
		RANK() OVER
			(PARTITION BY a.WorkCenter
				ORDER BY a.RqmtTypeRank,a.SchedLatestStart,a.rowid)
		AS PegRank,
		
		a.WorkCenter,
		b.materialType,
		a.Material,
		b.description,
		a.PeggedRqmt,

		CASE
			when 0+ a.RqmtTypeRank = 1 and b.materialType is 'FERT' then 'confirmed customer order'
			when 0+ a.RqmtTypeRank = 1 and b.materialType is not 'FERT' then 'process order'
			when 0+ a.RqmtTypeRank = 2 and b.materialType is 'FERT' then 'customer order, not yet confirmed'
			when 0+ a.RqmtTypeRank = 2 and b.materialType is not 'FERT' then 'forecast element'
		else null end as RqmtType,
		
		a.RqmtQty,
		a.RqmtUnit,
		b.SAPUnitPrice,
case a.RqmtUnit = b.baseUnit when true then a.RqmtQty*b.SAPUnitPrice else null end as SAPimpactvalue,

		a.SchedLatestStart,
		a.SchedLatestFinish,
		SUM(a.SAPDuration) AS SAPDuration,
		a.DurUnit,
		a.RqmtQty/(SUM(a.SAPDuration)*60.0) AS SAPEffectiveLineSpeed,
		a.RqmtUnit||' *MIN^-1' AS LineSpeedUnit

	FROM (textimport as a left join materialcontext as b on a.Material = b.material)
	left join WorkCenter as c on a.WorkCenter = c.workcenter
where a.WorkCenter in (select workcenter from WorkCenter)
GROUP BY a.WorkCenter, a.Material, a.PeggedRqmt
order by c.rowid,a.RqmtTypeRank,a.SchedLatestStart,a.rowid
;





.headers on
.mode tabs
.once "CM01-data.dat"
select * from GroupByOrder;
