package todo3.codesquad.domain;

import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;


public interface UserRepository extends CrudRepository<User,Long> {
    @Query("SELECT user_name FROM user WHERE user_id = :userId")
    String findByUserId(@Param("userId") String userId);
}
