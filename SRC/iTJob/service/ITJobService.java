package iTJob.service;

import iTJob.dao.ITJobDao;
import iTJob.dto.ITJobDto;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ITJobService {

    public void insertFromExcel(Connection conn, HashMap<Integer, ITJobDto> map) throws SQLException {
        ITJobDao iTJobDao = new ITJobDao(conn);
        iTJobDao.insertITJobFromExcel(map);
    }

    public void insert(Connection conn, ITJobDto iTJobDto) throws SQLException {
        ITJobDao iTJobDao = new ITJobDao(conn);
        iTJobDao.insertITJob(iTJobDto);
    }

    public Map<Integer, ITJobDto> search(Connection conn,  String[] dates, String[] status, String[] owner) throws SQLException {
        ITJobDao iTJobDao = new ITJobDao(conn);
        return iTJobDao.searchITJob(dates, status, owner);
    }

    public boolean updateITJob(Connection conn, Map<String, Map<String, String>> map) throws SQLException {
        ITJobDao iTJobDao = new ITJobDao(conn);
        return iTJobDao.updateITJob(map);
    }

    public boolean deleteITJob(Connection conn, List<String> noList) throws SQLException {
        ITJobDao iTJobDao = new ITJobDao(conn);
        return iTJobDao.deleteITJob(noList);
    }
}
