package todo3.codesquad.domain;

import org.json.JSONObject;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ColRepository extends CrudRepository<Col, Long> {


    @Query("select id from col where col.deleted = false")
    List<Integer> findColIdByNotDeleted();

    @Query("select col_name from col where col.id = :id")
    String findColNameByNotDeleted(@Param("id") Integer id);




    @Query("SELECT * FROM col WHERE col_name = :colName")
    Optional<Col> findByColName(@Param("colName") String colName);

    @Query("select * from col where category_name = :categoryName")
    Optional<Col> findByCategoryName(@Param("categoryName") String categoryName);

    @Query("select * from card where card.id = :moveCardId")
    Optional<Card> findByMoveCardId(@Param("moveCardId") Long moveCardId);

    @Query("select col from card where card.id = :moveCardId")
    Optional<Long> findColIdByCardId(@Param("moveCardId") Long moveCardId);

    @Query("select * from card inner join col where card.col = col.id and card.id = 1")
    String[] findByMoveCardId2();

}
