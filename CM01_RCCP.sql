-- CM01 [Rough Cut] Capacity Planning
-- process CM01 for display on a site-wide Gantt chart

-- just the start dates and finish dates

-- Authored by David Harris 2025-07-15

-- ====Drop======================================================================

drop table if exists CM01import;
drop table if exists WorkCenter;
drop table if exists textimport;
drop table if exists GroupByOrder;

-- ===Import=======================================================================

CREATE TABLE CM01import (_1,_2,_3,_4,_5,_6,_7,_8,_9,_10,_11,_12,
	_13,_14,_15,_16,_17,_18,_19)
;

.import "s:/CC Concurrence Workspace/HARRISDM/RM06analyst/SAPdata/Charfixdata/SAPspool_20250715/charfix-FP10000209115.TXT" CM01import

-- ===Prepare CM01==========================================================



CREATE TABLE WorkCenter (
       business,
       technology,
       workcenter,
       description
);

INSERT INTO WorkCenter
	VALUES
		('pharma','Solids','72A','L72_Blister'),
		('pharma','Solids','78A','L78_Pouch'),
		('pharma','Solids','79A','L79_Pouch'),
		('pharma','Solids','82A','L82_Bottles'),
		('pharma','Solids','83A','L83_Bottles'),

		('pharma','Liquids','5A','L5_4ozBottles'),
		('pharma','Liquids','61A','L61_GlassBottles'),
		('pharma','Liquids','62A','L62_8ozBottles'),
		('pharma','Liquids','63A','L63_4ozBottles'),

		('beauty','LipCare','20A','L20_Labeler-FilledSticks'),
		('beauty','LipCare','26A','L26_HighspeedFilledSticks'),
		('beauty','LipCare','27A','L27_FilledSticks'),
		('beauty','LipCare', '36A','L36_L37_AlloydLipcare'),
		('beauty','LipCare', '40A','L40_Single-LipcareFFS'),
		('beauty','LipCare', '41A','L41_Multi-LipcareFFS'),
		('beauty','LipCare', '45A','L45_LipcareRefill'),

		('pharma','Topicals', '31A','L31_Monistat-FG'),
		('pharma','Topicals', '32A','L32_Anbesol-FG'),
		('pharma','Topicals', '34A','L34_Monistat-FG'),
		('pharma','Topicals', '35A','L35_Anbesol-Monistat-WIP'),
		('pharma','Topicals', '50A','L50_Monistat-WIP'),
		('pharma','Topicals', '51A','L51_PrepH-FG'),
		('pharma','Topicals', '57A','L57_PrepH-Monistat-WIP'),
		('pharma','Topicals', '58A','L58_Monistat-WIP'),
		('pharma','Topicals', '59A','L59_PrepH-Monistat-WIP'),
		('pharma','Topicals', '66A','L66_PrepH-FG'),
		('pharma','Topicals', '77A','L77_Monistat-WIP'),

		('beauty','Cosmetics', '64A','L64_Anbesol-WIP'),
		('beauty','Cosmetics', '65A','L65_Deo-FG'),
		('beauty','Cosmetics', '91A','L91_Deo-WIP'),
		('beauty','Cosmetics', '92A','L92_misc-FG'),
		('beauty','Cosmetics', '97A','L97_Deo-FG'),

		('beauty','aerosol', 'AER201','aerosol201'),
		('beauty','aerosol', 'AER202','aerosol202'),
		('beauty','aerosol', 'AER203','aerosol203'),
		('beauty','aerosol', 'AER204','aerosol204'),
		('beauty','aerosol', 'AER205','aerosol205')
;





CREATE  TABLE textimport AS 
	SELECT
		rowid,
		TRIM(_3) AS WorkCenter,
		TRIM(_4) AS Material,
		TRIM(_6) AS PeggedRqmt,

		trim(_18) as RqmtTypeRank,
		
		CASE
			when trim(_18)+0 = 1 and trim(_4) like 'F%' then 'confirmed customer order'
			when trim(_18)+0 = 1 and trim(_4) not like 'F%' then 'process order'
			when trim(_18)+0 = 2 and trim(_4) like 'F%' then 'customer order, not yet confirmed'
			when trim(_18)+0 = 2 and trim(_4) not like 'F%' then 'forecast element'
		else null end as RqmtType,
		
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
		RANK() OVER
			(PARTITION BY WorkCenter
				ORDER BY RqmtTypeRank,SchedLatestStart,rowid)
		AS PegRank,
		
		WorkCenter,
		Material,
		PeggedRqmt,
		RqmtType,
		RqmtQty,
		RqmtUnit,
		SchedLatestStart,
		SchedLatestFinish,

		-- (
		-- 	SELECT MonthPeriod
		-- 	FROM ShiftCalendar
		-- 	WHERE strftime('%Y',SchedLatestStart) = ISOYear
		-- 		AND strftime('%m',SchedLatestStart) = ISOMonth
		-- ) AS SchedMonthPeriod,

		SUM(SAPDuration) AS SAPDuration,
		DurUnit,
		RqmtQty/(SUM(SAPDuration)*60.0) AS SAPEffectiveLineSpeed,
		RqmtUnit||' *MIN^-1' AS LineSpeedUnit

	FROM textimport
	GROUP BY WorkCenter, Material, PeggedRqmt
;


